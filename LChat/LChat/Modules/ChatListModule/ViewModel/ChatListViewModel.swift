//
//  ChatsListViewModel.swift
//  LingoChat
//
//  Created by Егор on 01.03.2021.
//

import Foundation


protocol ChatListViewModelProtocol: class {
    
    var chats: Bindable<[Chat]> { get set }
    var selectedChat: Chat? { get }
    var downloadedMessages: [String: [Message]] { get }
    var countUnSeenMessages: UInt { get set }
    
    func getChatRooms()
    func selectChat(_ chat: Chat)
    func observeChats()
    func downloadMessages(fromChat id: String, limit: UInt)
}


class ChatListViewModel: ChatListViewModelProtocol {
    
    
    //MARK: - Properties -
    
    let chatManager: ChatServiceProtocol
    var chats = Bindable<[Chat]>()
    var downloadedMessages = [String : [Message]]()
    var selectedChat: Chat?
    var countUnSeenMessages: UInt = 0

    //MARK: - Init -
    
    init(chatManager: ChatService) {
        self.chatManager = chatManager
    }
    
    //MARK: - Methods -
    
    
    func downloadMessages(fromChat id: String, limit: UInt) {
        
        DispatchQueue.global(qos: .background).async {
            
            self.chatManager.getMessages(from: id, limit: limit) { [weak self] messages in
                
                guard let self = self else { return }
                
                if !messages.isEmpty {
                 
                    messages.forEach { message in
                        
                        if message.isSeen == false {
            
                            self.countUnSeenMessages += 1
                        }
                    }
                    
                    if let index = self.chats.value?.firstIndex(where: {$0.id == id}) {
                        
                        self.chats.value?[index].countUnSeenMessages = self.countUnSeenMessages
                    } else {
                        assertionFailure()
                    }
                }
                self.countUnSeenMessages = 0
                self.downloadedMessages[id] = messages
            }
        }
    }
    
    
    
    
    func getChatRooms() {
                
        chatManager.getAllUserChats { [weak self] chats in
            
            if !chats.isEmpty {
                
                self?.chats.value = chats.sorted { $0.id < $1.id }
            }
        }
    }
    
    
    
    func selectChat(_ chat: Chat) {
        
        self.selectedChat = chat
        selectedChat?.messages = downloadedMessages[chat.id]
    }
    
    
    func observeChats() {
        
        chatManager.observeChats { changedChat in
            
            guard let chats = self.chats.value else { return }
            
            for index in 0..<chats.count {
                
                if chats[index].id == changedChat.id {
                    
                    self.chats.value?[index] = changedChat
                    self.countUnSeenMessages += 1
                }
            }
        }
    }
}
