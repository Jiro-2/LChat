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
    
    
    static func buildSettingModule() -> UIViewController {
        
        let viewModel = SettingViewModel()
        let vc = SettingViewController(viewModel: viewModel)
        
        return vc
    }
    
    
    static func buildProfileBodule() -> UIViewController {
        
        let storageService = FBStorageService()
        let databaseService = FBDatabaseService()
        
        let viewModel = ProfileViewModel(storageService: storageService, databaseService: databaseService)
        let vc = ProfileViewController(viewModel: viewModel)
        
        return vc
    }
    
    
    static func buildHomeModule() -> UIViewController {
        
        let chatManager = FBChatService()
        let databaseService = FBDatabaseService()
        let viewModel = ChatRoomsViewModel(chatManager: chatManager,
                                          databaseService: databaseService)
                
        let chatRoomsVC = ChatRoomsViewController(viewModel: viewModel)
        let settingVC = self.buildSettingModule()
        let profileVC = self.buildProfileBodule()
        
        let homeViewModel = HomeViewModel()
        let tabBarController = HomeTabBarController(viewModel: homeViewModel)
        tabBarController.setViewControllers([chatRoomsVC, profileVC, settingVC], animated: true)
                
        return tabBarController
    }
}
