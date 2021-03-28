//
//  SignUpViewModel.swift
//  LChat
//
//  Created by Егор on 25.03.2021.
//

import Foundation

protocol SignUpViewModelProtocol {
    
    func navigateToLogin()
    func showCountries()
    func getLocaleCallingCode() -> Int? 
}


final class SignUpViewModel: SignUpViewModelProtocol {
 
    private let countrySelector: CountrySelectable
    
    init(countrySelector: CountrySelectable) {
        self.countrySelector = countrySelector
    }
    
    
    
    func getLocaleCallingCode() -> Int? {
        
        var code: Int?
        
        if let localeCode = Locale.current.regionCode?.uppercased() {
            
           let country = countrySelector.getCountry(localeCode)
            code = country.callingCode
        }
        
        return code
    }
    
    
    
    func navigateToLogin() {
        
        
        
    }
    
    
    func showCountries() {
        
        
        
    }
}
