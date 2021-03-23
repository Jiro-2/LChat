//
//  Chat.swift
//  LingoChat
//
//  Created by Егор on 01.03.2021.
//

import Foundation

struct Chat: Identifiable {
    
    var id: String
    var member: User
    var lastMessage: String?
    var countUnSeenMessages: UInt?
    var messages: [Message]?
}
