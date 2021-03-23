//
//  FBAuthManager.swift
//  LingoChat
//
//  Created by Егор on 02.02.2021.
//

import Foundation
import Firebase
import FirebaseDatabase

protocol FBAuthManagerProtocol {
    
    func registerUser(with firstName: String, lastName: String, phoneNumber: String, completionBlock: @escaping (_ succes: Bool) -> ())
    func signin(WithCode code: String, verificationID id: String, completionBlock: @escaping (_ succes: Bool) -> ())
    func verifyPhoneNumber(_ phone: String, completionBlock: @escaping (_ succes: Bool) -> ())
    func checkPresenceUserInDataBase(_ completionHandler: @escaping (Bool) -> ())
    func checkUserAgainstDatabase(completion: @escaping (_ success: Bool, _ error: NSError?) -> ())
    func getUserPhone() -> String?
}


class FBAuthManager: FBAuthManagerProtocol {
    
    private let rootRef = Database.database(url: "https://lingochat-7b2d0-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    
    func registerUser(with firstName: String, lastName: String, phoneNumber: String, completionBlock: @escaping (_ succes: Bool) -> ()) {
        
        if !firstName.isEmpty && !lastName.isEmpty && !phoneNumber.isEmpty {
            
            
            checkPresenceUserInDataBase { isPresence in
                
                if isPresence {
                    
                    completionBlock(true)
                    
                } else {
                    
                    guard let userID = Auth.auth().currentUser?.uid else {
                                                                            print("User ID is nil")
                                                                                             return }
                    
                    self.rootRef.child("users").child(userID)
                    
                    var dict = [String: Any]()
                    
                    dict.updateValue(firstName, forKey: "firstName")
                    dict.updateValue(lastName, forKey: "lastName")
                    dict.updateValue(phoneNumber, forKey: "phone")
                    
                    self.rootRef.child("users").child(userID).updateChildValues(dict)
                }
            }
        }
    }
    
    
    
    func verifyPhoneNumber(_ phone: String, completionBlock: @escaping (Bool) -> ()) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
            
            if let error = error {
                
                print(error.localizedDescription)
                completionBlock(false)
                
            } else {
                
                UserDefaults.standard.setValue(verificationID, forKey: "verificationID")
                completionBlock(true)
            }
        }
    }
    
    
    
    func checkUserAgainstDatabase(completion: @escaping (_ success: Bool, _ error: NSError?) -> ()) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        currentUser.getIDTokenForcingRefresh(true, completion:  { idToken, error in
            
          if let error = error {
            
            completion(false, error as NSError?)
            print(error.localizedDescription)
            
          } else {
            
            completion(true, nil)
          }
        })
      }
    
    
    
    
    func checkPresenceUserInDataBase(_ completionHandler: @escaping (Bool) -> ()) {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            
            print("User not signed in")
            return
        }
        
       
        rootRef.child("users").child(userID).observe(.value) { snapshot in
            
            if snapshot.exists() {
                
                completionHandler(true)
                
            } else {
                
                completionHandler(false)
            }
        }
    }
    
    
    
    func signin(WithCode code: String, verificationID id: String, completionBlock: @escaping (Bool) -> ()) {
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            
            if let error = error {
                
                print(error.localizedDescription)
                completionBlock(false)
                
            } else {
                completionBlock(true)
                
                
            }
        }
    }
    
    func getUserPhone() -> String? {
     
        guard let user = Auth.auth().currentUser else { print("User nil", #function)
                                                                          return nil }
        return user.phoneNumber
    }
}
