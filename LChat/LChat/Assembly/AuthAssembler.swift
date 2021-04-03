//
//  LoginAssembler.swift
//  LChat
//
//  Created by Егор on 25.03.2021.
//

import UIKit


class AuthAssembler {
    
    static func buildLoginModule() -> UIViewController {
        
        let countrySelector = CountrySelector()
        let authService = FBAuthService()
        
        let viewModel = LoginViewModel(authService: authService, countrySelector: countrySelector)
        let viewController = LoginViewController(viewModel: viewModel)
        
        return viewController
    }
    
    
    static func buildSignUpModule() -> UIViewController {
    
        let countrySelector = CountrySelector()
        let authService = FBAuthService()
        let viewModel = SignUpViewModel(countrySelector: countrySelector, authService: authService)
        let viewController = SignUpViewController(viewModel: viewModel)
        
        return viewController
    }
    
    static func buildVerificationModule() -> UIViewController {
     
        let authService = FBAuthService()
        let viewModel = VerificationViewModel(authService: authService)
        let viewController = VerificationViewController(viewModel: viewModel)
        
        return viewController
    }
    
    static func buildCountriesModule() -> UIViewController {
     
        let countrySelector = CountrySelector()
        let viewModel = CountriesViewModel(countrySelector: countrySelector)
        let viewController = CountriesViewController(viewModel: viewModel)
        
        return viewController
    }
}
