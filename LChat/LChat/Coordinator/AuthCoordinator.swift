//
//  LoginCoordinator.swift
//  LChat
//
//  Created by Егор on 27.03.2021.
//

import UIKit

final class AuthCoordinator: Coordinator {
    
    //MARK: - Properties -
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    //MARK: - Init -
    
    init(navController: UINavigationController) {
        navigationController = navController
    }
    
    
    //MARK: - Methods -
    
    func start() {
        
        guard let vc = LoginAssembler.buildLoginModule() as? LoginViewController else { return }
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    
    func navigateToSignUp() {
        
        guard let vc = LoginAssembler.buildSignUpModule() as? SignUpViewController else { return }
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
