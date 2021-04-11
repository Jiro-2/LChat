//
//  User.swift
//  LingoChat
//
//  Created by Егор on 12.02.2021.
//

import Foundation

enum UserProperty: String {
    case id
    case userName
    case phone
    case location
    case bio
}


struct User: Identifiable {
    
    let id: String
    var username: String
    var location: String?
    var phone: String?
    var bio: String?
}
