//
//  Assembler.swift
//  LingoChat
//
//  Created by Егор on 14.02.2021.
//

import UIKit

final class MainAssembler {
    
    static func buildSearchUserModule() -> UIViewController {
        
        let searcher = FIRDatabaseSearcher()
        let viewModel = SearchUserViewModel(databaseSearcher: searcher)
        let viewController = SearchUserViewController(viewModel: viewModel)
        
        return viewController
    }
    
    
    static func buildChatModule() -> UIViewController {
        
        let chatManager = ChatService()
        let searcher = FIRDatabaseSearcher()
        let viewModel = ChatViewModel(chatManager: chatManager, searcher: searcher)
        let viewController = ChatViewController(viewModel: viewModel)
        
        return viewController
    }
    
    static func buildChatListModule() -> UIViewController {
        
        let chatManager = ChatService()
        let viewModel = ChatListViewModel(chatManager: chatManager)
                
        let viewController = ChatListViewController(viewModel: viewModel)
        
        let homeViewModel = HomeViewModel()
        let tabBarController = HomeTabBarController(viewModel: homeViewModel)
        tabBarController.setViewControllers([viewController], animated: true)
                
        return tabBarController
    }
}
