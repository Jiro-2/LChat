//
//  Chat.swift
//  LingoChat
//
//  Created by Егор on 01.03.2021.
//

import Foundation

struct Chat: Identifiable {
    
  //MARK: - Properties -

    let id: String
    let members: [User]
    
    var messages: [Message] {
        
        didSet {
            
            calculateUnSeenMessages()
            setLastMessage()
        }
    }
    
    private(set) var lastMessage: String?
    private(set) var countUnSeenMessages: UInt?
    
    
    //MARK: - Methods -
    
    private mutating func setLastMessage() {
        
        self.lastMessage = self.messages.last?.text
    }
    
    
    
    private mutating func calculateUnSeenMessages() {
                
        let unSeenMessages = messages.filter() { $0.isSeen == false }
        self.countUnSeenMessages = UInt(unSeenMessages.count)
    }
}
