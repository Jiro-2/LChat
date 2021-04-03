//
//  LoginCoordinator.swift
//  LChat
//
//  Created by Егор on 27.03.2021.
//

import UIKit

final class AuthCoordinator: Coordinator {
    
    //MARK: - Properties -
    
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    //MARK: - Init -
    
    init(navController: UINavigationController) {
        navigationController = navController
    }
    
    
    //MARK: - Methods -
    
    func start() {
        
        guard let vc = AuthAssembler.buildLoginModule() as? LoginViewController else { return }
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    
    func navigateToSignUp() {
        
        guard let vc = AuthAssembler.buildSignUpModule() as? SignUpViewController else { return }
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToVerification() {
     
        guard let vc = AuthAssembler.buildVerificationModule() as? VerificationViewController else { return }
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToCountries() {
        
        guard let vc = AuthAssembler.buildCountriesModule() as? CountriesViewController else { return }
        vc.coordinator = self
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func didFinishAuth() {
        
        parentCoordinator?.childDidFinish(self)
    }
}
