import UIKit

final class SettingAssembler {
    
    
    static func buildSettingModule() -> UIViewController {
        
        let viewModel = SettingsViewModel()
        let vc = SettingsViewController(viewModel: viewModel)
        let navigationController = UINavigationController()
        let coordinator = SettingCoordinator(navigationController: navigationController)
        vc.coordinator = coordinator

        return vc
    }
    
    
    
    static func buildLanguageModule() -> UIViewController {
                
        let viewModel = LanguagesViewModel()
        let viewController = LanguagesViewController(viewModel: viewModel)
        
        return viewController
    }
}
