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
    
        
    static func buildProfileModule() -> UIViewController {
        
        let storageService = FBStorageService()
        let databaseService = FBDatabaseService()
        
        let viewModel = ProfileViewModel(storageService: storageService, databaseService: databaseService)
        let vc = ProfileViewController(viewModel: viewModel)
        
        return vc
    }
    
    
    
    static func buildHomeModule() -> UIViewController {
        
        let chatManager = FBChatService()
        let databaseService = FBDatabaseService()
        let storageService = FBStorageService()
        
        let viewModel = ChatRoomsViewModel(chatManager: chatManager,
                                           databaseService: databaseService,
                                           storageService: storageService)
                
        let chatRoomsVC = ChatRoomsViewController(viewModel: viewModel)
        let settingVC = SettingAssembler.buildSettingModule()
        let profileVC = self.buildProfileModule()
        
        let homeViewModel = HomeViewModel()
        let tabBarController = HomeTabBarController(viewModel: homeViewModel)
        tabBarController.setViewControllers([chatRoomsVC, profileVC, settingVC], animated: true)
                
        return tabBarController
    }
}
