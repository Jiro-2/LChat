//
//  AuthorizationViewModel.swift
//  LChat
//
//  Created by Егор on 24.03.2021.
//

import Foundation



protocol LoginViewModelProtocol {
    
    func navigateToSignUp()
    func getLocaleCallingCode() -> String?
}


final class LoginViewModel: LoginViewModelProtocol {
    
    let navigator: LoginNavigator
    let loginService: FBLoginServiceProtocol
    let countrySelector: CountrySelectable
    
    init(navigator: LoginNavigator, loginService: FBLoginServiceProtocol, countrySelector: CountrySelectable) {
        self.navigator = navigator
        self.loginService = loginService
        self.countrySelector = countrySelector
    }
    
    
    
    func login(With phone: String) {
        
        loginService.login(withPhone: phone) { result in
            
            switch result {
            
            case .failure(let error):
                
                print(error)
                
            case .success(let verificationId):
            
                print(verificationId)
            }
        }
    }
    
    
    
    func getLocaleCallingCode() -> String? {
        
        var code: String?
        
        if let localeCode = Locale.current.regionCode?.uppercased() {
            
           let country = countrySelector.getCountry(localeCode)
            code = String(describing: country.callingCode)
        }
        
        return code
    }
    
    
    func navigateToSignUp() {
        
        navigator.navigate(to: .signUp, presented: false)
    }
}
