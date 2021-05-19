import Foundation
import Firebase

protocol ChatViewModelProtocol {
    
    var interLocutor: User? { get set }
    var currentUser: User? { get }
    var isChatExists: Bindable<Bool>  { get }
    var messages: Bindable<[Message]> { get set }
    var chatRoomId: String? { get set }
    var isDownloadedMessages: Bool { get set }
    
    func startChat()
    func isExistsChat()
    func sendMessage(text: String)
    func startObservingChat()
    func stopObservingChat()
}



final class ChatViewModel: ChatViewModelProtocol {
    
    var chatManager: FBChatServiceProtocol
    var chatRoomId: String?
    var isChatExists = Bindable<Bool>()
    var messages = Bindable<[Message]>()
    var currentUser: User?
    var interLocutor: User?
    var isDownloadedMessages = false {
        
        didSet {
            
            if  isDownloadedMessages {
                
                self.isChatExists.value = true
            }
        }
    }
    
    //MARK: - Init -
    
    init(chatManager: FBChatServiceProtocol) {
        self.chatManager = chatManager
        isChatExists.value = false
        setCurrentUser()
    }
    
    
    //MARK: - Methods -
    
    
    func isExistsChat() {
        
        guard let user = self.interLocutor else { return }
        
        chatManager.isExistsChat(WithUser: user) { [weak self] chatId in
            
            if let id = chatId {
                
                self?.isChatExists.value = true
                self?.chatRoomId = id
                
            } else {
                
                self?.chatRoomId = nil
                self?.isChatExists.value = false
            }
        }
    }
    
    
    
    
    func startChat() {
        
        guard let interLocutor = self.interLocutor else { assertionFailure(); return }
        
        chatManager.createChat(with: interLocutor) { [weak self] error, chatId  in
            
            if let error = error {
                
                assertionFailure(error.errorDescription ?? "Error - \(#function)")
                
            } else {
                
                self?.isChatExists.value = true
                self?.chatRoomId = chatId
                self?.startObservingChat()
            }
        }
    }
    
    
    
    
    func sendMessage(text: String) {
        
        guard let currentUser = self.currentUser else { assertionFailure(); return }
        guard let id = self.chatRoomId else { assertionFailure(); return }
        chatManager.sendMessageBy(user: currentUser, text: text, chatId: id, completion: nil)
    }
    
    
    
    
    
      func startObservingChat() {
        
        guard let id = self.chatRoomId else { assertionFailure(); return }
        
        
        if isDownloadedMessages {
        
            chatManager.startObservingOnlyNewMessagesIn(chatRoom: id) { [weak self] message in
                
                guard let message = message,
                      let messages = self?.messages.value else { assertionFailure(); return }
                
                if messages.contains(message) {
                    
                    self?.messages.value?.removeLast() // remove duplicate
                }
                
                
                if self?.messages.value == nil {
                    
                    self?.messages.value = [message]
                    
                } else {
                    
                    self?.messages.value?.append(message)
                }
            }
            
            
        } else {
            
            chatManager.startObserving(chatRoom: id) { [weak self] message in
                
                guard let message = message else { return }
                
                if self?.messages.value == nil {
                    
                    self?.messages.value = [message]
                    
                } else {
                    
                    self?.messages.value?.append(message)
                }
            }
            
        }
    }
    
    
    
    func stopObservingChat() {
        
        guard let id = self.chatRoomId else { /*assertionFailure();*/print("ERROR: Chat id not exist"); return }
        chatManager.stopObserving(ChatRoom: id)
    }
    
    
    
    private func setCurrentUser() {
        
        guard let user = Auth.auth().currentUser,
              let username = user.displayName else { assertionFailure(); return }
        
        self.currentUser = User(id: user.uid, username: username)
    }
}
