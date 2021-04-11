//
//  FBDatabaseService.swift
//  LChat
//
//  Created by Егор on 09.04.2021.
//

import Foundation
import FirebaseDatabase


protocol FBDatabaseServiceProtocol {
    
    func getData(for path: String, completion: @escaping (Result<Any, DBError>) -> ())
    func observe(path: String, completion: @escaping (Result<Any, DBError>) -> ())
    func stopObserving(for path: String)
}


final class FBDatabaseService: FBDatabaseServiceProtocol {
    
    
    private let databaseReference = Database.database(url: "https://lchat-9bb0e-default-rtdb.europe-west1.firebasedatabase.app").reference()

    
    //MARK: - Methods -
    
    
    func observe(path: String, completion: @escaping (Result<Any, DBError>) -> ()) {
        
        databaseReference.child(path).observe(.childAdded) { snap in
            
            if let value = snap.value {
                
                completion(.success(value))
                
            } else {
            
                completion(.failure(.failedToFetch))
                
            }
        }
    }
    
    
    func stopObserving(for path: String) {
        
        databaseReference.child(path).removeAllObservers()
    }
    
    
    
    
    func getData(for path: String, completion: @escaping (Result<Any, DBError>) -> ()) {
        
        databaseReference.child(path).observeSingleEvent(of: .value) { snap in
            
            if let value = snap.value {
                
                completion(.success(value))
                
            } else {
            
                completion(.failure(.failedToFetch))
                
            }
        }
    }
}









