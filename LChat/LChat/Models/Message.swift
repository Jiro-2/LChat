//
//  Message.swift
//  LingoChat
//
//  Created by Егор on 15.02.2021.
//

import Foundation
import MessageKit

struct Message: Identifiable {
    
    let memberId: String
    let text: String
    let id: String
    let date: String
    var isSeen: Bool
}


extension Message: MessageType {
    
    var sender: SenderType {
        
        return Sender(senderId: memberId, displayName: "")
    }
    
    var messageId: String {
        
        return UUID().uuidString
    }
    
    var sentDate: Date {
        
        return Date()
    }
    
    var kind: MessageKind {
        
        .text(text)
    }
}
