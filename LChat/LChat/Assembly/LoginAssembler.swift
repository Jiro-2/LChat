//
//  LoginAssembler.swift
//  LChat
//
//  Created by Егор on 25.03.2021.
//

import UIKit


class LoginAssembler {
    
    static func buildLogInModule(navigator: LoginNavigator) -> UIViewController {
        
        let viewModel = LoginViewModel(navigator: navigator)
        let viewController = LoginViewController(viewModel: viewModel)
        
        return viewController
    }
    
    
    static func buildSignUpModule(navigator: LoginNavigator) -> UIViewController {
    
        let viewModel = SignUpViewModel(navigator: navigator)
        let viewController = SignUpViewController(viewModel: viewModel)
        
        return viewController
    }
}
