//
//  ChatViewModel.swift
//  LingoChat
//
//  Created by Егор on 15.02.2021.
//


import Foundation
import Firebase

protocol ChatViewModelProtocol {
    
    var interLocutor: User? { get set }
    var currentUser: User? { get }
    var isChatExists: Bindable<Bool>  { get }
    var messages: Bindable<[Message]> { get }

    func startChat()
    func checkExistenceChat()
    func sendMessage(text: String)
    func stopObservingChat()
}



final class ChatViewModel: ChatViewModelProtocol {
    
    var chatManager: FBChatServiceProtocol
    var currentChatId: String?
    var isChatExists = Bindable<Bool>()
    var messages = Bindable<[Message]>()
    var currentUser: User?
    var interLocutor: User?
    
    
    //MARK: - Init -
    
    init(chatManager: FBChatServiceProtocol) {
        self.chatManager = chatManager
        isChatExists.value = false
        setCurrentUser()
    }
    
    
    //MARK: - Methods -
    
    
    func checkExistenceChat() {
        
        guard let user = self.interLocutor else { return }
        
        chatManager.checkExistenceChat(WithUser: user) { [weak self] chatId in
            
            if let id = chatId {
                
                self?.isChatExists.value = true
                self?.currentChatId = id
                self?.observeChat()
                
            } else {
                
                self?.currentChatId = nil
                self?.isChatExists.value = false
            }
        }
    }
    
    
    
    
    func startChat() {
        
        guard let interLocutor = self.interLocutor else { assertionFailure(); return }
        
        chatManager.createChat(with: interLocutor) { [weak self] error, chatId  in
            
            if let error = error {
                
                print(error.errorDescription ?? "Error - \(#function)")
                assertionFailure()
                
            } else {
                
                self?.isChatExists.value = true
                self?.currentChatId = chatId
                self?.observeChat()
            }
        }
    }
    
    
    
    
    func sendMessage(text: String) {
        
        guard let currentUser = self.currentUser else { assertionFailure(); return }
        guard let id = self.currentChatId else { assertionFailure(); return }
        chatManager.sendMessageBy(user: currentUser, text: text, chatId: id, completion: nil)
    }
    
    
    func stopObservingChat() {
        
        guard let id = self.currentChatId else { assertionFailure(); return }
        chatManager.stopObserving(ChatRoom: id)
    }
    
    
    
    private  func observeChat() {
        
        guard let id = self.currentChatId else { assertionFailure(); return }
        
        chatManager.startObserving(chatRoom: id) { [weak self] message in
            
            guard let message = message else { return }
            
            if self?.messages.value == nil {
                
                self?.messages.value = [message]
                
            } else {
                
                self?.messages.value?.append(message)
            }
        }
    }
    
    
    
    
    private func setCurrentUser() {
        
        guard let user = Auth.auth().currentUser,
              let username = user.displayName else { assertionFailure(); return }
        
        self.currentUser = User(id: user.uid, username: username)
    }
}
