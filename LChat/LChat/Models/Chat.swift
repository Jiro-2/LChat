import Foundation

struct Chat: Identifiable {
    
  //MARK: - Properties -

    let id: String
    let interlocutors: (currentUser: User, interlocutor: User)
    
    var messages: [Message] {
        
        didSet {
            
            calculateUnSeenMessages()
            lastMessage = messages.last?.text
        }
    }
    
    private(set) var lastMessage: String?
    private(set) var countUnSeenMessages: UInt?
    
    
    //MARK: - Methods -
    
    private mutating func calculateUnSeenMessages() {
                
        let unSeenMessages = messages.filter() { $0.isSeen == false && $0.memberId == interlocutors.interlocutor.id }
        self.countUnSeenMessages = UInt(unSeenMessages.count)
    }
}


