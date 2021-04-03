//
//  MainCoordinator.swift
//  LChat
//
//  Created by Егор on 03.04.2021.
//


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
        
         let vc = MainAssembler.buildChatListModule()
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    
    
    func navigateToSearch() {
        
       let vc = MainAssembler.buildSearchUserModule()
       self.navigationController.pushViewController(vc, animated: true)
    }
    
    
    func navigateToChat() {
        
        let vc = MainAssembler.buildChatModule()
        self.navigationController.pushViewController(vc, animated: true)
    }
}
