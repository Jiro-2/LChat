//
//  LoginNavigator.swift
//  LingoChat
//
//  Created by Егор on 15.01.2021.
//

import UIKit

class LoginNavigator: Navigator {
    
    private weak var navigationController: UINavigationController?
    
    enum Destination {
        case register
        case signin
        case authentication
        case selectionCountry
        case signUp
        case login
    }
    
    
    //MARK: init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    
    func navigate(to destination: Destination, presented: Bool) {
        
        let viewController = makeViewController(for: destination)
        
        if presented {
            
            navigationController?.present(viewController, animated: true, completion: nil)
            
        } else {
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    //MARK: Private methods
    
    private func makeViewController(for destination: Destination) -> UIViewController {

        switch destination {
        
        case .register:
            
            let viewController = RegisterViewController()
            let viewModel = RegisterViewModel(navigator: self)
            let countrySelector = CountrySelector()
            let authManager = FBAuthManager()
            
            viewModel.authManager = authManager
            viewModel.countrySelector = countrySelector
            viewController.viewModel = viewModel
            
            return viewController
            
        case .authentication:
            
            let authManager = FBAuthManager()
            let viewModel = AuthCodeViewModel(authManager: authManager, navigator: self)
            let viewController = AuthCodeViewController(viewModel: viewModel)
            
            return viewController
            
        case .signin:
            
            let viewController = SignInViewController()
            let viewModel = SigninViewModel(navigator: self)
            let countrySelector = CountrySelector()
            let authManager = FBAuthManager()
            
            viewModel.authManager = authManager
            viewModel.countrySelector = countrySelector
            viewController.viewModel = viewModel
            
            return viewController
            
        case .selectionCountry:
            
            let countrySelector = CountrySelector()
            let viewModel = CountriesViewModel(countrySelector: countrySelector)
            let viewController = CountriesViewController()
            
            viewModel.navigator = self
            viewController.viewModel = viewModel
            
            return viewController
            
        case .signUp:
            
            return LoginAssembler.buildSignUpModule(navigator: self)
            
        case .login:
            
            return LoginAssembler.buildLogInModule(navigator: self)
        }
    }
}
