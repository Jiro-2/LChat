//
//  UserSearcher.swift
//  LingoChat
//
//  Created by Егор on 12.02.2021.
//

import Foundation
import FirebaseDatabase
import Firebase


enum Category: String {
    case userName
}


protocol DatabaseSearchable {
    
    func searchBy(category: Category, word: String, completionHandler: @escaping (_ result: Array<Any>) -> ())
    func searchChatId(withUser user: User, completion: @escaping (_ chatID: String?) -> ())
    func searchUserBy(id: String, completion: @escaping (User?) -> ())

}


final class FIRDatabaseSearcher: DatabaseSearchable {
   
    //MARK: - Properties
    
    private let databaseRef = Database.database(url: "https://lingochat-7b2d0-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    
    
    //MARK: - Methods
    
    func searchBy(category: Category, word: String, completionHandler: @escaping (_ result: Array<Any>) -> ()) {
        
        
        switch category {
        
        case .userName:
            
            var users = [User]()
            
            databaseRef.child(FirebasePath.Path.users.rawValue).queryOrdered(byChild: Category.userName.rawValue).queryStarting(atValue: word).queryEnding(atValue: word + "\u{f8ff}").observeSingleEvent(of: .value) { snapshot in
                
                guard let values = snapshot.value as? [String: AnyObject] else { return }
                
                let ids = values.keys
                
                for id in ids {
                    
                    guard let userName = snapshot.childSnapshot(forPath: id).childSnapshot(forPath: "userName").value as? String else { return }
                    let user = User(id: id, userName: userName)
                    
                    users.append(user)
                }
                completionHandler(users)
            }
            completionHandler(users)
        }
    }
    
    
     func searchUserBy(id: String, completion: @escaping (User?) -> ()) {
         
         self.databaseRef.child(FirebasePath.Path.users.rawValue).child(id).observeSingleEvent(of: .value) { snap in
             
             if snap.exists() {
                 
                 if let userDict = snap.value as? [String: String] {
                     
                     if let userName = userDict["userName"] {
                         
                         let user = User(id: id, userName: userName)
                         
                         completion(user)
                     }
                 }
                 
             } else {
                 completion(nil)
             }
         }
     }

    
    

    
    func searchChatId(withUser user: User, completion: @escaping (_ chatID: String?) -> ()) {
        
        guard let userID = Auth.auth().currentUser?.uid else { completion(nil)
            return }
        
        let pathToChats = databaseRef.child(FirebasePath.Path.chats.rawValue)
        
        
        pathToChats.child(userID + user.id).observeSingleEvent(of: .value) { snap in
            
            if snap.exists() {
                
                completion(snap.key)
            } else {
                
                pathToChats.child(user.id + userID).observeSingleEvent(of: .value) { snap in
                    
                    if snap.exists() {
                        
                        completion(snap.key)
                        
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
}
