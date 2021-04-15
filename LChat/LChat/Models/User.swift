//
//  User.swift
//  LingoChat
//
//  Created by Егор on 12.02.2021.
//

import Foundation

struct User: Identifiable {
    
    let id: String
    var username: String
    var location: String?
    var phone: String?
    var bio: String?
}
