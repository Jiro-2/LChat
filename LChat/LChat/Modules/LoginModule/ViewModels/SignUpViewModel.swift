//
//  SignUpViewModel.swift
//  LChat
//
//  Created by Егор on 25.03.2021.
//

import Foundation

protocol SignUpViewModelProtocol {
    
    func navigateToLogin()
}


final class SignUpViewModel: SignUpViewModelProtocol {
 
    let navigator: LoginNavigator
    
    init(navigator: LoginNavigator) {
        self.navigator = navigator
    }
    
    
    func navigateToLogin() {
        
        navigator.navigate(to: .login, presented: false)
        
    }
    
 
}
