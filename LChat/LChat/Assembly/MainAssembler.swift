//
//  Assembler.swift
//  LingoChat
//
//  Created by Егор on 14.02.2021.
//

import UIKit

final class MainAssembler {
    
    static func buildSearchUserModule() -> UIViewController {
        
        let searcher = FBSearchService()
        let viewModel = SearchUserViewModel(databaseSearcher: searcher)
        let viewController = SearchUserViewController(viewModel: viewModel)
        
        return viewController
    }
    
    
    static func buildChatModule() -> UIViewController {
        
        let chatManager = FBChatService()
        let viewModel = ChatViewModel(chatManager: chatManager)
        let viewController = ChatViewController(viewModel: viewModel)
        
        return viewController
    }
    
    static func buildHomeModule() -> UIViewController {
        
        let chatManager = FBChatService()
        let databaseService = FBDatabaseService()
        let viewModel = ChatRoomsViewModel(chatManager: chatManager,
                                          databaseService: databaseService)
                
        let viewController = ChatRoomsViewController(viewModel: viewModel)
        
        let homeViewModel = HomeViewModel()
        let tabBarController = HomeTabBarController(viewModel: homeViewModel)
        tabBarController.setViewControllers([viewController], animated: true)
                
        return tabBarController
    }
}
