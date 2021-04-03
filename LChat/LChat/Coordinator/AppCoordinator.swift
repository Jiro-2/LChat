//
//  AppCoordinator.swift
//  LChat
//
//  Created by Егор on 04.04.2021.
//

import UIKit



final class AppCoordinator: Coordinator {
    
    
    //MARK: - Properties -
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var isLoggedIn = false
    

    //MARK: - Init -
    
    init(navController: UINavigationController) {
        navigationController = navController
    }
    
    
    //MARK: - Methods -
    
    func start() {
        
        isLoggedIn ? showHome() : showAuthentication()
    }
    
    
    
    func childDidFinish(_ child: Coordinator?) {
        
        for (index, coordinator) in childCoordinators.enumerated() {
            
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    
    
    private func showAuthentication() {
        
        let authCoordinator = AuthCoordinator(navController: navigationController)
        authCoordinator.start()
        childCoordinators.append(authCoordinator)
    }
    
    
    private func showHome() {
        
        let mainCoordinator = MainCoordinator(navController: navigationController)
        mainCoordinator.start()
        childCoordinators.append(mainCoordinator)
    }
    
}
