import UIKit

final class SettingCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    
    //MARK: - Init -
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    //MARK: - Methods -
    
    func start() {
        
        guard let vc = SettingAssembler.buildSettingModule() as? SettingsViewController else { assertionFailure(); return }
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    
    func showLanguages() {
        
        guard let vc = SettingAssembler.buildLanguageModule() as? LanguagesViewController else { assertionFailure(); return}
        self.navigationController.pushViewController(vc, animated: true)
    }
}
