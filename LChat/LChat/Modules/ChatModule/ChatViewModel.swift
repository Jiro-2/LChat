//
//  ChatViewModel.swift
//  LingoChat
//
//  Created by Егор on 15.02.2021.
//


import Foundation

protocol ChatViewModelProtocol {
    
//    var currentChat: Bindable<Chat> { get set }
//
//    func checkExistenceChatWith(user: User, completion: @escaping (Bool) -> ())
//    func getCurrentSenderID() -> String
//    func startChat(with user: User)
//    func sendMessageBy(user: User, text: String, completion: @escaping (_ error: Error?) -> ())
//    func updateMessages(isSeen: Bool)
//    func getMessages()
//    func setObserve()
//
//    func checkDownloadedMessages()

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
    
}
