//
//  DBError.swift
//  LChat
//
//  Created by Егор on 09.04.2021.
//

import Foundation

enum DBError: String, Error {
    
    case failedToFetch
    case failedToWrite
}
