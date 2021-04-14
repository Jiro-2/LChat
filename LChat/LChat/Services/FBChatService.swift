//
//  FBChatService.swift
//  LChat
//
//  Created by Егор on 04.04.2021.
//

import Foundation
import Firebase


protocol FBChatServiceProtocol {
    
    func isExistsChat(WithUser user: User, completion: @escaping (_ chatId: String?) -> ())
    func createChat(with user: User, completion: @escaping (ChatError?, String?) -> ())
    func sendMessageBy(user: User, text: String, chatId: String, completion: (() -> ())?)
    
    func startObserving(chatRoom id: String, completion: @escaping (_ receivedMessage: Message?) -> ())
    func startObservingOnlyNewMessagesIn(chatRoom id: String, completion: @escaping (_ receivedMessage: Message?) -> ())
    func stopObserving(ChatRoom id: String)
}



final class FBChatService: FBChatServiceProtocol {
    
    //MARK: - Property -
    
    private let databaseReference = Database.database(url: "https://lchat-9bb0e-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    
    //MARK: - Methods -
    
    
    func sendMessageBy(user: User, text: String, chatId: String, completion: (() -> ())?) {
        
        let date = DateFormatter().todaysDate(in: "yyyy-MM-dd HH:mm")
        let messageID = Int(NSDate.timeIntervalSinceReferenceDate * 1000)
        
        let dictMessage: [String: Any] = ["date": date,
                                          "sentBy": user.username,
                                          "text": text,
                                          "isSeen": false]
        
        
        databaseReference.child("messages/\(chatId)/\(messageID)").setValue(dictMessage)
    }
    
    
    
    
    func startObserving(chatRoom id: String, completion: @escaping (_ receivedMessage: Message?) -> ()) {
        
        let pathToChat = databaseReference.child("messages/\(id)")
        
        pathToChat.queryOrderedByKey().observe(.childAdded) { snap in
            
            if snap.exists() {
                
                let messageDict = snap.value as? [String: Any]
                
                if let dict = messageDict {
                    
                    guard let date = dict["date"] as? String,
                          let senderId = dict["sentBy"] as? String,
                          let text = dict["text"] as? String,
                          let isSeen = dict["isSeen"] as? Bool else {assertionFailure(); return }
                    
                    let message = Message(memberId: senderId, text: text, id: snap.key, date: date, isSeen: isSeen)

                    completion(message)
                    
                } else {
                    
                    completion(nil)
                }
            }
        }
    }
    
    
    
    
    func startObservingOnlyNewMessagesIn(chatRoom id: String, completion: @escaping (_ receivedMessage: Message?) -> ()) {
        
        let pathToChat = databaseReference.child("messages/\(id)")
        
        pathToChat.queryOrderedByKey().queryLimited(toLast: 1).observe(.childAdded) { snap in
            
            if snap.exists() {
                
                let messageDict = snap.value as? [String: Any]
                
                if let dict = messageDict {
                    
                    guard let date = dict["date"] as? String,
                          let senderId = dict["sentBy"] as? String,
                          let text = dict["text"] as? String,
                          let isSeen = dict["isSeen"] as? Bool else {assertionFailure(); return }
                    
                    let message = Message(memberId: senderId, text: text, id: snap.key, date: date, isSeen: isSeen)

                    completion(message)
                    
                } else {
                    
                    completion(nil)
                }
            }
        }
    }
    
    
    
    
    
    
    func stopObserving(ChatRoom id: String) {
        
        databaseReference.child("messages/\(id)").removeAllObservers()
    }
    
    
    
    
    
    func createChat(with user: User, completion: @escaping (ChatError?, String?) -> ()) {
        
        guard let currentUser = Auth.auth().currentUser else { completion(.failedStartChat, nil); return }
        let chatId = user.id + currentUser.uid
        
        if let username = currentUser.displayName {
            
            let value = ["0" : username, "1" : user.username]
            let timeStamp = Int(NSDate.timeIntervalSinceReferenceDate * 1000)

            databaseReference.child("chats/\(chatId)").setValue(value)
            databaseReference.child("userChats/\(username)/\(timeStamp)").setValue(chatId)
            databaseReference.child("userChats/\(user.username)/\(timeStamp)").setValue(chatId)
            completion(nil, chatId)
            
        } else {
            
            completion(.failedStartChat, nil)
        }
    }
    
    
    
    
    
    func isExistsChat(WithUser user: User, completion: @escaping (_ chatId: String?) -> ()) {
        
        guard let currentUser  = Auth.auth().currentUser else { return }
       
        let firstVersionChatId = currentUser.uid + user.id
        let secondVersionChatId = user.id + currentUser.uid

        
        databaseReference.child("chats/\(firstVersionChatId)").observeSingleEvent(of: .value) { snap in
            
            if snap.exists() {
                completion(snap.key)
                return
            }
        }
        
        
        databaseReference.child("chats/\(secondVersionChatId)").observeSingleEvent(of: .value) { snap in
            
            if snap.exists() {
                
                completion(snap.key)
                
            } else {
                
                completion(nil)
            }
        }
    }
}
