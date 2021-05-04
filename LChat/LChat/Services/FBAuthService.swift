import Foundation
import Firebase

protocol FBAuthServiceProtocol {
    
    func signUp(WithVerificationId id: String, verificationCode code: String, username: String, phoneNumber: String, completion: @escaping (Error?) -> ())
    func verify(PhoneNumber phone: String, completion: @escaping (Result<String?, Error>) -> ())
    func login(WithVerificationId id: String, verificationCode code: String, completion: @escaping (Error?) -> ())
    func isDuplicate(_ data: String, in category: SearchCategory, completion: @escaping (Bool) -> ())
    
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
                
                self.setProfileData()
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
                
                guard let userId = Auth.auth().currentUser?.uid else { assertionFailure(); return }
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                
                let dict = ["phone": phoneNumber, "id": userId]
                self.databaseReference.child("users").child(username).setValue(dict)
                completion(nil)
            }
        }
    }
    
    
    
    
    func checkExistenceUserInDB(ByPhone phone: String, completion: @escaping (_ isExist: Bool) -> ()) {
        
        databaseReference
            .child("users")
            .queryOrdered(byChild: "phone")
            .queryStarting(atValue: phone)
            .queryEnding(atValue: phone + "\u{f8ff}").observeSingleEvent(of: .value) { snap in
                
                snap.exists() ? completion(true) : completion(false)
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
    
    
    
    func isDuplicate(_ data: String, in category: SearchCategory, completion: @escaping (Bool) -> ()) {
        
        var dbQuery: DatabaseQuery
        
        switch category {
        
        case .username:
            
            dbQuery = databaseReference
                .child("users")
                .queryOrdered(byChild: category.rawValue)
                .queryStarting(atValue: data)
                .queryEnding(atValue: data + "\u{f8ff}")
            
            
        case .phone:
            
            dbQuery = databaseReference
                .child("users")
                .queryOrdered(byChild: category.rawValue)
                .queryStarting(atValue: data)
                .queryEnding(atValue: data + "\u{f8ff}")
        }
        
        
        dbQuery.observeSingleEvent(of: .value) { snap in
            
            if snap.exists() {
                
                completion(true)
                
            } else {
                
                completion(false)
            }
        }
    }
    
    
    
    
    private func setProfileData() {
        
        guard let phone = Auth.auth().currentUser?.phoneNumber else { assertionFailure(); return }
        
        databaseReference
            .child("users")
            .queryOrdered(byChild: "phone")
            .queryStarting(atValue: phone)
            .queryEnding(atValue: phone + "\u{f8ff}").observeSingleEvent(of: .value) { snap in
                
                
                guard let dict = snap.value as? [String:Any] else { assertionFailure(); return }
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = dict.keys.first
                changeRequest?.commitChanges(completion: { error in
                    
                    if let error = error {
                        
                        assertionFailure(error.localizedDescription)
                }
            })
        }
    }
}
