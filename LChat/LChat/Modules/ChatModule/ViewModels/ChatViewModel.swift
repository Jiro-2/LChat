//
//  ChatViewModel.swift
//  LingoChat
//
//  Created by Егор on 15.02.2021.
//



//MARK: TODO
// 1 Проверить загружены ли уже сообщения если нет то начать загрузку


import Foundation

protocol ChatViewModelProtocol {
    
    var currentChat: Bindable<Chat> { get set }
    
    func checkExistenceChatWith(user: User, completion: @escaping (Bool) -> ())
    func getCurrentSenderID() -> String
    func startChat(with user: User)
    func sendMessageBy(user: User, text: String, completion: @escaping (_ error: Error?) -> ())
    func getMessages()
    func setObserve()
}


final class ChatViewModel: ChatViewModelProtocol {
    
    var chatManager: ChatServiceProtocol
    var databaseSearcher: DatabaseSearchable
    var currentChat = Bindable<Chat>()

    //MARK: - Init -
    
    init(chatManager: ChatServiceProtocol, searcher: DatabaseSearchable) {
        self.chatManager = chatManager
        self.databaseSearcher = searcher
    }
    
    
    //MARK: - Methods -
    
    func checkExistenceChatWith(user: User, completion: @escaping (Bool) -> ()) {
        
        self.databaseSearcher.searchChatId(withUser: user) { chatID in
            
            self.getChatBy(id: chatID!)
            
            chatID != nil ? completion(true) : completion(false)
        }
    }
    
    
    
    func setObserve() {
        
        if let id = self.currentChat.value?.id {
            
            self.chatManager.observe(chatRoom: id) { [weak self] message in
                
                guard let self = self else { return }
                guard let message = message else { return }
                
                if self.currentChat.value == nil {
                                        
                    self.currentChat.value?.messages = [message]
                    
                } else {
                    
                    self.currentChat.value?.messages?.append(message)
                }
            }
        }
    }
    
    
    func getMessages() {
        
        if let id = self.currentChat.value?.id {
            
            self.chatManager.getMessages(from: id, limit: 100) { [weak self] messages in
                
                guard let self = self else { return }
                
                let sortedMessagesByID = messages.sorted { $0.id < $1.id }
                self.currentChat.value?.messages = sortedMessagesByID
            }
        }
    }
    
    
    
    func sendMessageBy(user: User, text: String, completion: @escaping (_ error: Error?) -> ()) {
        
        if let id = self.currentChat.value?.id {
            
            self.chatManager.sendMessageBy(member: user, text: text, chatId: id) {  error in
                
                if let err = error {
                    
                    completion(err)
                    assertionFailure("Sending message failed \(err)")
                    
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    
    
    func getCurrentSenderID() -> String {
        
        return self.chatManager.currentUserId
    }
    
    
        
    func startChat(with user: User) {
        
        self.chatManager.createChat(withMember: user) { error in
            
            if let err = error {
                
                print("Start chat failed! Error - ", err)
                
            } else {
                
                self.databaseSearcher.searchChatId(withUser: user) { [weak self] id in
                    
                    guard let self = self, let id = id else { assertionFailure("id of new chat is nil")
                                                                                                        return }
                  
                    self.chatManager.getChatBy(id: id) { chat in
                        
                        assert(chat != nil, "Receive chat is failed")
                        
                        self.currentChat.value = chat
                        self.setObserve()
                    }
                }
            }
        }
    }
    
    
    
   //MARK: - Private -
    
    func getChatBy(id: String) {
        
        self.chatManager.getChatBy(id: id) { [weak self] chat in
         
            if let chat = chat {
                self?.currentChat.value = chat
                self?.getMessages()
                self?.setObserve()
            }
        }
    }
}
