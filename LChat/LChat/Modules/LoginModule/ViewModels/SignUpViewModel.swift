//
//  SignUpViewModel.swift
//  LChat
//
//  Created by Егор on 25.03.2021.
//

import Foundation

protocol SignUpViewModelProtocol {
    
    func navigateToLogin()
    func getLocaleCallingCode() -> String? 
}


final class SignUpViewModel: SignUpViewModelProtocol {
 
   private let navigator: LoginNavigator
    private let countrySelector: CountrySelectable
    
    init(navigator: LoginNavigator, countrySelector: CountrySelectable) {
        self.navigator = navigator
        self.countrySelector = countrySelector
    }
    
    
    
    func getLocaleCallingCode() -> String? {
        
        var code: String?
        
        if let localeCode = Locale.current.regionCode?.uppercased() {
            
           let country = countrySelector.getCountry(localeCode)
            code = String(describing: country.callingCode)
        }
        
        return code
    }
    
    
    
    func navigateToLogin() {
        
        navigator.navigate(to: .login, presented: false)
        
    }
    
 
}
