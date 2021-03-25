//
//  FBSearchService.swift
//  LingoChat
//
//  Created by Егор on 21.03.2021.
//

import Foundation
import FirebaseDatabase

protocol FBObserveServiceProtocol {
    
    func setObserve(for path: String, completion: @escaping ([String: String]?) -> ())
    func stopObserving(in path: String)
}


final class FBObserveService: FBObserveServiceProtocol {
    
    private let databaseReference = Database.database(url: "https://lchat-9bb0e-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    
    func setObserve(for path: String, completion: @escaping ([String: String]?) -> ()) {
        
        databaseReference.child(path).observe(.value) { snap in
            
           if let value = snap.value as? [String:String] {
                
            completion(value)
            
           } else {
            
            completion(nil)
           }
        }
    }
    
    
    func stopObserving(in path: String) {
     
        databaseReference.child(path).removeAllObservers()
    }
}
