//
//  ChatViewModel.swift
//  LingoChat
//
//  Created by Егор on 15.02.2021.
//


import Foundation

protocol ChatViewModelProtocol {
    
    var currentChat: Bindable<Chat> { get set }
    
    func checkExistenceChatWith(user: User, completion: @escaping (Bool) -> ())
    func getCurrentSenderID() -> String
    func startChat(with user: User)
    func sendMessageBy(user: User, text: String, completion: @escaping (_ error: Error?) -> ())
    func updateMessages(isSeen: Bool)
    func getMessages()
    func setObserve()
    
    func checkDownloadedMessages()

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
            
            if let id = chatID {
                
                self.getChatBy(id: id)
            }
            
            chatID != nil ? completion(true) : completion(false)
        }
    }
    
    
    
    func checkDownloadedMessages() {
        
        if let messages = self.currentChat.value?.messages {

            if !messages.isEmpty {
             
                print("Messages downloaded!")
                
            } else {
                
                print("Messages wasn't downloaded!")
            }
        }
    }
    
    
    
    
    
    func getMessages() {
        
//        if let id = self.currentChat.value?.id {
//
//            self.chatManager.getMessages(from: id, limit: 100) { [weak self] messages in
//
//                guard let self = self else { return }
//
//                let sortedMessagesByID = messages.sorted { $0.id < $1.id }
//                self.currentChat.value?.messages = sortedMessagesByID
//            }
//        }
    }
    
    
    
    
    
    func setObserve() {
                
        if let id = self.currentChat.value?.id {
            
            self.chatManager.observe(chatRoom: id) { [weak self] message in
               
                print(#function)
                
                guard let self = self else { return }
                guard let message = message else { return }
                
                if self.currentChat.value == nil {
                                        
                    self.currentChat.value?.messages = [message]
                    
                } else {
                    
                    if !self.currentChat.value!.messages!.contains(message) {
                        
                        self.currentChat.value?.messages?.append(message)
                        
                    } else {
                        
                        return
                    }
                }
                self.updateMessages(isSeen: true)
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
    
    
    
    
    func updateMessages(isSeen: Bool) {

        let messages = self.currentChat.value?.messages?.filter() {$0.isSeen == !isSeen && $0.memberId != getCurrentSenderID()}

        if let messages = messages, let chatId = currentChat.value?.id {

            if !messages.isEmpty {

                self.chatManager.update(messages: messages, in: chatId, isSeen: isSeen)
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
