//
//  AuthorizationViewModel.swift
//  LChat
//
//  Created by Егор on 24.03.2021.
//

import Foundation



protocol LoginViewModelProtocol {
    
    func navigateToSignUp()
    func showCountries()
    func getLocaleCallingCode() -> Int?
    func login(WithCallingCode code: String, phoneNumber phone: String, completion: @escaping (_ isSuccess: Bool) -> ())
}


final class LoginViewModel: LoginViewModelProtocol {
    
    let loginService: FBLoginServiceProtocol
    let countrySelector: CountrySelectable
    
    init(loginService: FBLoginServiceProtocol, countrySelector: CountrySelectable) {
        self.loginService = loginService
        self.countrySelector = countrySelector
    }
    
    
    
    func login(WithCallingCode code: String, phoneNumber phone: String, completion: @escaping (_ isSuccess: Bool) -> ()) {
        
        
        if code != "+000" && phone.isValidPhone {
            
            loginService.login(withPhone: code + phone) { result in

                switch result {

                case .failure(let error):

                    print(error)
                    completion(false)

                case .success(let verificationId):

                    print(verificationId)
                    completion(true)
                }
            }
        }
    }
    
    
    
    func getLocaleCallingCode() -> Int? {
        
        var code: Int?
        
        if let regionCode = Locale.current.regionCode?.uppercased() {
            
           let country = countrySelector.getCountry(regionCode)
            code = country.callingCode
        }
        
        return code
    }
    
    
    func navigateToSignUp() {
        
    }
    
    
    func showCountries() {

        
    }
}
