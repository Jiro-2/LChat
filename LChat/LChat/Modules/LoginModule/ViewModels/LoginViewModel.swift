//
//  AuthorizationViewModel.swift
//  LChat
//
//  Created by Егор on 24.03.2021.
//

import Foundation



protocol LoginViewModelProtocol {
    
    func navigateToSignUp()
}


final class LoginViewModel: LoginViewModelProtocol {
    
    let navigator: LoginNavigator
    
    init(navigator: LoginNavigator) {
        self.navigator = navigator
    }
    
    
    
    func navigateToSignUp() {
        
        navigator.navigate(to: .signUp, presented: false)
    }
}
