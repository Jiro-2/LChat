//
//  FIRDatabaseLoader.swift
//  LingoChat
//
//  Created by Егор on 10.03.2021.
//

import Foundation
import Firebase
import FirebaseDatabase


protocol DatabaseLoadable {
        
    func getAllUserChats(userId: String, completion: @escaping (_ chats: [Chat]) -> ())
    func getChatBy(chatId: String, userId: String, completion: @escaping (Chat?) -> ())
    func getMessages(from chat: String, limit: UInt, completionHandler: @escaping (_ messages: [Message]) -> ())
    func getUserBy(id: String, completion: @escaping (User?) -> ())
}




final class FBDatabaseLoader: DatabaseLoadable {
    
    private let databaseReference = Database.database(url: "https://lingochat-7b2d0-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    
    
     func getUserBy(id: String, completion: @escaping (User?) -> ()) {
        
        self.databaseReference.child(FirebasePath.Path.users.rawValue).child(id).observeSingleEvent(of: .value) { snap in
            
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
    
    
    
    func getAllUserChats(userId: String,completion: @escaping ([Chat]) -> ()) {
        
        let pathToChats = self.databaseReference.child(FirebasePath.Path.userChats.rawValue)
        
        pathToChats.child(userId).observeSingleEvent(of: .value) { snap in
            
            if snap.exists() {
                
                if let value = snap.value as? [String : String] {
                    var chats = [Chat]()
                    
                    let chatsCount = value.values.count
                    
                    value.values.forEach { chatId in
                        
                        self.getChatBy(chatId: chatId, userId: userId) { chat in
                            
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
    
    
    
    
    
    func getChatBy(chatId: String, userId: String, completion: @escaping (Chat?) -> ()) {
       
       databaseReference.child(FirebasePath.Path.chats.rawValue).child(chatId).observeSingleEvent(of: .value) { [weak self] snap in
           
           if snap.exists() {
               
               guard let chatDict = snap.value as? [String : Any] else { return }
               
               
               if let lastMessage = chatDict["lastMessage"] as? String,
                  let membersId = chatDict["members"] as? [String] {
                   
                   
                   var memberId = ""
                   
                   membersId.forEach { id in
                       
                    if id != userId {
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
    
    
    
    
    func getMessages(from chat: String, limit: UInt, completionHandler: @escaping (_ messages: [Message]) -> ()) {
        
        let pathToMessages = self.databaseReference.child(FirebasePath.Path.messages.rawValue).child(chat)
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
}
