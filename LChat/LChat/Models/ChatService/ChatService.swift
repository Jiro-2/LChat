//
//  ChatService.swift
//  LingoChat
//
//  Created by Егор on 16.02.2021.
//

import Foundation
import FirebaseDatabase
import Firebase

protocol ChatServiceProtocol {
    
    var currentUserId: String { get }
    
    func createChat(withMember member: User, completionHandler:  @escaping (_ error: Error?) -> ())
    func deleteChatBy(id: String, completionHandler: @escaping (_ success: Bool) -> ())
    func getAllUserChats(completion: @escaping (_ chats: [Chat]) -> ())
    func getChatBy(id: String, completion: @escaping (Chat?) -> ())

    
    func sendMessageBy(member: User, text: String, chatId: String, completion: @escaping (_ error: Error?) -> ())
    
    func getMessages(from chat: String, limit: UInt, completionHandler: @escaping (_ messages: [Message]) -> ())
    func observeChats(completion: @escaping ((_ changedChat: Chat) -> ()))
    func observe(chatRoom: String, completion: @escaping (_ receivedMessage: Message?) -> ())

    //    func deleteMessage()
}


enum MathType {
    case increment
    case decrement
}



final class ChatService: ChatServiceProtocol {
    
    //MARK: - Properties -
    
    private let databaseRef = Database.database(url: "https://lingochat-7b2d0-default-rtdb.europe-west1.firebasedatabase.app").reference()
    var currentUserId = Auth.auth().currentUser?.uid ?? ""
    
    
    
    var AllUserChats = [String:String]()
    
    
    init() {
        observeAllUserChats()
    }
    
    
    //MARK: - Methods -
    
    
    
    //MARK: Public
    
    func createChat(withMember member: User, completionHandler: @escaping (_ error: Error?) -> ()) {
        
        
        if self.currentUserId.isEmpty {
            assertionFailure("Can't create new chat, because id of current user is empty.")
            completionHandler(nil)
        }
        
        
        checkChatAvailability(withMember: member) { isExist in
            
            if isExist {
                print("chat already exist in DB")
                completionHandler(nil)
                
            } else {
                print("chat not exist in DB")
                
                //Create new chat in DB
                
                let idOfNewChat = self.currentUserId + member.id
                let newChatPath = self.databaseRef.child(FirebasePath.Path.chats.rawValue).child(idOfNewChat)
                
                newChatPath.child("members").setValue(["0": self.currentUserId, "1": member.id])
                
                //add new chat in list chat rooms of User in DB
                
                let timeStamp = Int(NSDate.timeIntervalSinceReferenceDate * 1000)
                self.databaseRef.child(FirebasePath.Path.userChats.rawValue).child(self.currentUserId).child("\(timeStamp)").setValue(idOfNewChat)
                self.databaseRef.child(FirebasePath.Path.userChats.rawValue).child(member.id).child("\(timeStamp)").setValue(idOfNewChat)
    
                
                self.sendMessageBy(member: member, text: "Chat was create", chatId: idOfNewChat) { error in
                    
                    if error == nil {
                        
                        completionHandler(nil)
                    } else if let err = error {
                        
                        completionHandler(err)
                    }
                }
            }
        }
    }
    
    
    
    
    
    func getChatBy(id: String, completion: @escaping (Chat?) -> ()) {
       
       databaseRef.child(FirebasePath.Path.chats.rawValue).child(id).observeSingleEvent(of: .value) { [weak self] snap in
           
           if snap.exists() {
               
               guard let chatDict = snap.value as? [String : Any] else { return }
               
               
               if let lastMessage = chatDict["lastMessage"] as? String,
                  let membersId = chatDict["members"] as? [String] {
                   
                   
                   var memberId = ""
                   
                   membersId.forEach { id in
                       
                    if id != self?.currentUserId {
                           memberId = id
                       }
                   }
                   
                   if !memberId.isEmpty {
                       
                    self?.getUserBy(id: memberId) { user in
                           
                           if let member = user {
                               
                               let chat = Chat(id: snap.key,
                                               member: member,
                                               lastMessage: lastMessage)
                               
                               completion(chat)
                               
                           } else {
                               completion(nil)
                           }
                       }
                   }
               }
           }
       }
   }
    
    
    
    
    
    func getAllUserChats(completion: @escaping ([Chat]) -> ()) {
        
        let pathToChats = self.databaseRef.child(FirebasePath.Path.userChats.rawValue)
        
        pathToChats.child(currentUserId).observeSingleEvent(of: .value) { snap in
            
            if snap.exists() {
                
                if let value = snap.value as? [String : String] {
                    var chats = [Chat]()
                    
                    let chatsCount = value.values.count
                    
                    value.values.forEach { chatId in
                        
                        self.getChatBy(id: chatId) { chat in
                            
                            if let chat = chat {
                                chats.append(chat)
                            }
                            
                            if chats.count == chatsCount {
                                completion(chats)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    func sendMessageBy(member: User, text: String, chatId: String, completion: @escaping (_ error: Error?) -> ()) {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateToString = dateFormatter.string(from: date)
        let messageID = Int(NSDate.timeIntervalSinceReferenceDate * 1000)
        
        let dicMessage: [String: Any] = ["date": dateToString, "sentBy": member.id, "text": text, "isSeen": false]
        
        self.databaseRef.child(FirebasePath.Path.messages.rawValue).child(chatId).child("\(messageID)").setValue(dicMessage) { error, dataRef in
            
            if error == nil {
                
                self.addLastMessageInChat(chatId, text: text) { error in
                    
                    if let err = error {
                        
                        completion(err)
                        
                    } else {
                        completion(nil)
                    }
                }
            } else {
                completion(error)
            }
        }
        
        self.updateUnSeenMessagesCount(with: .increment, chatId: chatId)
    }
    
    
    
    
    func getMessages(from chat: String, limit: UInt, completionHandler: @escaping (_ messages: [Message]) -> ()) {
        
        let pathToMessages = self.databaseRef.child(FirebasePath.Path.messages.rawValue).child(chat)
        let dispatchGroup = DispatchGroup()
        
        pathToMessages.queryLimited(toLast: limit).observeSingleEvent(of: .value) { snap in
            
            guard let value = snap.value as? [String: AnyObject] else { return }
            
            var messages = [Message]()
            
            value.keys.forEach { id in
                
                if let messageDic = snap.childSnapshot(forPath: id).value as? [String: AnyObject] {
                    
                    guard let sender = messageDic["sentBy"] as? String,
                          let text = messageDic["text"] as? String,
                          let date = messageDic["date"] as? String,
                          let isSeen = messageDic["isSeen"] as? Bool else { assertionFailure()
                                                                                              return }
                   
                    dispatchGroup.enter()
                    
                    self.getUserBy(id: sender) { user in
                        
                        if let user = user {
                            
                            let message = Message(memberId: user.id, text: text, id: id, date: date, isSeen: isSeen)
                            messages.append(message)
                            
                            dispatchGroup.leave()
                        } else {
                            print("Debug: getting User failed in ", #function)
                        }
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                
                completionHandler(messages.reversed())
            }
        }
    }
    
    
    
    
    func observeChats(completion: @escaping ((_ changedChat: Chat) -> ())) {
                 
            let pathToChats = self.databaseRef.child(FirebasePath.Path.chats.rawValue)
            
            pathToChats.observe(.childChanged) { snap in
                
                for (_, value) in self.AllUserChats {
                    
                    if value == snap.key {
                        
                        self.getChatBy(id: value) { chat in
                            
                            if let chat = chat {
                                
                                completion(chat)
                        }
                    }
                }
            }
        }
    }
    
    
    func observeAllUserChats() {
        
        let pathToUserChats = self.databaseRef.child(FirebasePath.Path.userChats.rawValue).child(currentUserId)
        
        pathToUserChats.observe(.value) { snap in
            
            let value = snap.value as? [String : String]
            
            
            value?.keys.forEach({ key in
                
                self.AllUserChats[key] = value?[key]
            })
        }
    }
    
    
    
    
    
    func updateUnSeenMessagesCount(with type: MathType, chatId: String) {
        
       
        
     
    }
    
    
    
    func setNewCountUnSeenMessages(_ newCount: UInt, chatId: String) {
        
        
        
        
    }
    
    
    
    
    func observe(chatRoom: String, completion: @escaping (_ receivedMessage: Message?) -> ()) {
        
        let pathToChat = self.databaseRef.child(FirebasePath.Path.messages.rawValue).child(chatRoom)
        
        pathToChat.queryOrderedByKey().queryLimited(toLast: 1).observe(.childAdded) { snap in
            
            if snap.exists() {
                
                let messageDict = snap.value as? [String: Any]
                
                if let dict = messageDict {
                    
                    guard let date = dict["date"] as? String,
                          let senderId = dict["sentBy"] as? String,
                          let text = dict["text"] as? String,
                          let isSeen = dict["isSeen"] as? Bool else { return }
                    
                    let message = Message(memberId: senderId, text: text, id: snap.key, date: date, isSeen: isSeen)

                    completion(message)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    
    
    
    
    
    func deleteChatBy(id: String, completionHandler: @escaping (Bool) -> ()) {
        
        
    }
    
    
    
    func checkChatAvailability(withMember member: User, completionHandler: @escaping (_ isExist: Bool) -> ()) {
        
        guard let userID = Auth.auth().currentUser?.uid else { completionHandler(false)
            return }
        
        let pathToChats = databaseRef.child(FirebasePath.Path.chats.rawValue)
        
        pathToChats.child(userID + member.id).observeSingleEvent(of: .value) { snap in
            
            if snap.exists() {
                
                completionHandler(true)
            } else {
                
                pathToChats.child(member.id + userID).observeSingleEvent(of: .value) { snap in
                    
                    if snap.exists() {
                        
                        completionHandler(true)
                    } else {
                        completionHandler(false)
                    }
                }
            }
        }
    }
    
    
    //MARK: - Private
    
    
    private func addLastMessageInChat(_ chat: String, text: String, completionHandler: @escaping (_ error: Error?) ->()) {
        
        self.databaseRef.child(FirebasePath.Path.chats.rawValue).child(chat).child("lastMessage").setValue(text) { error, datRef in
            
            if let err = error {
                
                completionHandler(err)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    
    
    
    private func removeObserver(from reference: DatabaseReference) {
        
        reference.removeAllObservers()
    }
    
    
    
    
    
    private func getUserBy(id: String, completion: @escaping (User?) -> ()) {
        
        self.databaseRef.child(FirebasePath.Path.users.rawValue).child(id).observeSingleEvent(of: .value) { snap in
            
            if snap.exists() {
                
                if let userDict = snap.value as? [String: String] {
                    
                    if let userName = userDict["userName"] {
                        
                        let user = User(id: id, userName: userName)
                        
                        completion(user)
                    } else {
                        assertionFailure("user hasn't userName")
                    }
                }
                
            } else {
                completion(nil)
            }
        }
    }
}
