import Foundation
import MessageKit

struct Message: Identifiable, Equatable {
    
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
