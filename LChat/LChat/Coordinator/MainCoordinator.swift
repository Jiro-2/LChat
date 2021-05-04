import UIKit

final class MainCoordinator: Coordinator {
    
    //MARK: - Properties -
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    //MARK: - Init -
    
    init(navController: UINavigationController) {
        navigationController = navController
    }
    
    
    //MARK: - Methods -
    
    
    func start() {
        
        guard let vc = MainAssembler.buildHomeModule() as? HomeTabBarController else { assertionFailure(); return }
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    
    
    func showSearch() {
        
        guard let vc = MainAssembler.buildSearchUserModule() as? SearchUserViewController else { assertionFailure(); return }
        vc.coordinator = self
       self.navigationController.pushViewController(vc, animated: true)
    }
    
    
    
    func showChat() {
        
        let vc = MainAssembler.buildChatModule()
        self.navigationController.pushViewController(vc, animated: true)
    }
    

        
    
    func childDidFinish(_ child: Coordinator?) {
        
        for (index, coordinator) in childCoordinators.enumerated() {
            
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
