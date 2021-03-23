//
//  ObserveService.swift
//  LingoChat
//
//  Created by Егор on 10.03.2021.
//

import Foundation
import Firebase
import FirebaseDatabase

protocol ChatObservable {
    
    init(databaseLoader: DatabaseLoadable)

    func observe(chat: String, completion: @escaping (_ receivedMessage: Message?) -> ())
    func observeChanges(InChat id: String, eventType: DataEventType, completion: @escaping (_ message: Message?) -> ())
    func observeChats(eventType: DataEventType, completion: @escaping ((_ chat: Chat) -> ()))
}



final class ObserveService: ChatObservable {
  
    
    private let databaseReference = Database.database(url: "https://lingochat-7b2d0-default-rtdb.europe-west1.firebasedatabase.app").reference()
    private let databaseLoader: DatabaseLoadable
    
    
    init(databaseLoader: DatabaseLoadable) {
        self.databaseLoader = databaseLoader
    }
    
    
    
    func observeChanges(InChat id: String, eventType: DataEventType, completion: @escaping (_ message: Message?) -> ()) {
        
        let pathToChat = self.databaseReference.child(FirebasePath.Path.messages.rawValue).child(id)
        
        pathToChat.observe(eventType) { snap in
                        
            if snap.exists() {
                
                let messageDict = snap.value as? [String: Any]
                
                if let dict = messageDict {
                    
                    guard let date = dict["date"] as? String,
                          let senderId = dict["sentBy"] as? String,
                          let text = dict["text"] as? String,
                          let isSeen = dict["isSeen"] as? Bool else { assertionFailure()
                                                                                        return }
                    
                    let message = Message(memberId: senderId, text: text, id: snap.key, date: date, isSeen: isSeen)

                    completion(message)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    
    
    
    
    func observe(chat: String, completion: @escaping (_ receivedMessage: Message?) -> ()) {
        
        let pathToChat = self.databaseReference.child(FirebasePath.Path.messages.rawValue).child(chat)
                
        pathToChat.observe(.childAdded) { snap in
                        
            if snap.exists() {
                
                let messageDict = snap.value as? [String: Any]
                
                if let dict = messageDict {
                    
                    guard let date = dict["date"] as? String,
                          let senderId = dict["sentBy"] as? String,
                          let text = dict["text"] as? String,
                          let isSeen = dict["isSeen"] as? Bool else { assertionFailure()
                                                                                        return }
                    
                    let message = Message(memberId: senderId, text: text, id: snap.key, date: date, isSeen: isSeen)

                    completion(message)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    
    
    
    func observeChats(eventType: DataEventType, completion: @escaping ((_ chat: Chat) -> ())) {

            let pathToChats = self.databaseReference.child(FirebasePath.Path.chats.rawValue)

            pathToChats.observe(eventType) { snap in
                
                
              //  print(#function, snap.value)
        }
    }
}
