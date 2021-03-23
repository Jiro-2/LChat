//
//  Assembler.swift
//  LingoChat
//
//  Created by Егор on 14.02.2021.
//

import UIKit

final class MainAssembler {
    
    static func buildSearchUserModule(navigator: ChatNavigator) -> UIViewController {
        
        let searcher = FIRDatabaseSearcher()
        let viewModel = SearchUserViewModel(databaseSearcher: searcher)
        let viewController = SearchUserViewController(viewModel: viewModel)
        viewModel.navigator = navigator
        
        return viewController
    }
    
    
    static func buildChatModule() -> UIViewController {
        
        let chatManager = ChatService()
        let searcher = FIRDatabaseSearcher()
        let viewModel = ChatViewModel(chatManager: chatManager, searcher: searcher)
        let viewController = ChatViewController(viewModel: viewModel)
        
        return viewController
    }
    
    static func buildChatListModule(navigator: ChatNavigator) -> UIViewController {
        
        let chatManager = ChatService()
        let viewModel = ChatListViewModel(chatManager: chatManager)
        
        viewModel.navigator = navigator
        
        let viewController = ChatListViewController(viewModel: viewModel)
        
        let homeViewModel = HomeViewModel(navigator: navigator)
        let tabBarController = HomeTabBarController(viewModel: homeViewModel)
        tabBarController.setViewControllers([viewController], animated: true)
                
        return tabBarController
    }
}
