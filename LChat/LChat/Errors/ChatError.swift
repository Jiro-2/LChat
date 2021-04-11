//
//  ChatError.swift
//  LChat
//
//  Created by Егор on 07.04.2021.
//

import Foundation

enum ChatError: String, Error {
    
    case failedSendingMessage
    case failedGettingMessage
    case failedStartChat
}


extension ChatError: LocalizedError {
    
    public var errorDescription: String? {
     
        switch self {
        
        case .failedStartChat:
            
            return NSLocalizedString("The creation chat failed", comment: "")
        
        case .failedGettingMessage:
    
            return NSLocalizedString("The message was not received.", comment: "")
        
        case .failedSendingMessage:
            
            return NSLocalizedString("The message was not sent.", comment: "")
        }
    }
}
