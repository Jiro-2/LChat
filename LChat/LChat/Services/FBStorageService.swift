//
//  FBStorageService.swift
//  LingoChat
//
//  Created by Егор on 19.03.2021.
//

import Foundation
import FirebaseStorage

protocol FBStorageServiceProtocol {
    
    func upload(data: Data, path: String)
    func downloadData(from path: String, completion: @escaping (Result<Data?, Error>) -> ())
    func getURL(from path: String, completion: @escaping (Result<URL?, Error>) -> ())
}


final class FBStorageService: FBStorageServiceProtocol {
    
    
    private let storageReference = Storage.storage().reference()
    
    
    func upload(data: Data, path: String) {
        
        let ref = storageReference.child(path)
        
        ref.putData(data, metadata: nil) { metadata, error in
            
            if let error = error {
                
                print(error.localizedDescription)
                
            } else {
               
                print("Upload successfull")
            }
        }
    }
    
    
    
    func downloadData(from path: String, completion: @escaping (Result<Data?, Error>) -> ()) {
        
        let ref = storageReference.child(path)
        
        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success(data))
            }
        }
    }
    
    
    
    func getURL(from path: String, completion: @escaping (Result<URL?, Error>) -> ()) {
        
        let ref = storageReference.child(path)
     
        ref.downloadURL { url, error in
         
            if let error = error {
                
                completion(.failure(error))
    
            } else {
                
                completion(.success(url))
            }
        }
    }
}
