//
//  FBWriteService.swift
//  LingoChat
//
//  Created by Егор on 21.03.2021.
//

import Foundation
import FirebaseDatabase

protocol FBWriteServiceProtocol {
    
    func write(data: Any, in path: String, completion: @escaping (Error?) -> ())

}


final class FBWriteService: FBWriteServiceProtocol {
    
    private let databaseReference = Database.database(url: "https://lchat-9bb0e-default-rtdb.europe-west1.firebasedatabase.app").reference()


    func write(data: Any, in path: String, completion: @escaping (Error?) -> ()) {
        
        self.databaseReference.child(path).setValue(data) { error, _ in
            
            completion(error)
        }
    }
}
