//
//  FBLoginService.swift
//  LChat
//
//  Created by Егор on 23.03.2021.
//

import Foundation
import Firebase

protocol FBAuthServiceProtocol {
    
    func signUp(WithVerificationId id: String, verificationCode code: String, username: String, phoneNumber: String, completion: @escaping (Error?) -> ())
    func verify(PhoneNumber phone: String, completion: @escaping (Result<String?, Error>) -> ())
    func login(WithVerificationId id: String, verificationCode code: String, completion: @escaping (Error?) -> ())
    func checkDuplicate(username: String, completion: @escaping (_ isDuplicate: Bool) -> ())
    func save(verificationId id: String)
    func getVerificationId(WithDeletion deletion: Bool) -> String?
}


final class FBAuthService: FBAuthServiceProtocol {

    
    private let databaseReference = Database.database(url: "https://lchat-9bb0e-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    
    
    func login(WithVerificationId id: String, verificationCode code: String, completion: @escaping (Error?) -> ()) {
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            
            if let error = error {
                
                completion(error)
                
            } else {
                
                completion(nil)
            }
        }
    }
    
    
    func signUp(WithVerificationId id: String, verificationCode code: String, username: String, phoneNumber: String, completion: @escaping (Error?) -> ()) {
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            
            if let error = error {
                
                completion(error)
                
            } else {
                
                //create user in DB
                guard let userId = Auth.auth().currentUser?.uid else { assertionFailure(); return }
                let dict = ["username": username, "phone": phoneNumber]
                
                self.databaseReference.child("users").child(userId).setValue(dict)
                
                completion(nil)
            }
        }
    }
    
    
    
    func verify(PhoneNumber phone: String, completion: @escaping (Result<String?, Error>) -> ()) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
         
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success(verificationID))
                
            }
        }
    }
    
    

    
    
    func save(verificationId id: String) {
    
        UserDefaults.standard.setValue(id, forKey: "verificationId")
    }
    
    
    
    func getVerificationId(WithDeletion deletion: Bool) -> String? {
        
        let id = UserDefaults.standard.string(forKey: "verificationId")
        
        if deletion {
            
            UserDefaults.standard.removeObject(forKey: "verificationId")
        }
        
        return id
    }
    
    
    
    
     func checkDuplicate(username: String, completion: @escaping (_ isDuplicate: Bool) -> ()) {
             
        databaseReference.child("users").queryOrdered(byChild: "userName").queryStarting(atValue: username).queryEnding(atValue: username +  "\u{f8ff}").observeSingleEvent(of: .value) { snap in
            
            if snap.exists() {
             
                completion(true)
                
            } else {
                
                completion(false)
            }
        }
    }
}


