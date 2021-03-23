//
//  SigninViewModel.swift
//  LingoChat
//
//  Created by Егор on 21.01.2021.
//

import Foundation

protocol SigninViewModelProtocol: class {
    
    var navigator: LoginNavigator { get }
    func getLocaleCountry() -> Country?
    func verify(phone: String)
}

class SigninViewModel: SigninViewModelProtocol {
    
    //MARK: - Properties
    
    var navigator: LoginNavigator
    var countrySelector: CountrySelectable?
    var authManager: FBAuthManagerProtocol?
    
    
    //MARK: - Init
    
    init(navigator: LoginNavigator) {
        self.navigator = navigator
    }
    
    
    //MARK: - Methods
    
    func getLocaleCountry() -> Country? {
        
        if let regionCode = Locale.current.regionCode?.uppercased() {
            
            return countrySelector?.getCountry(regionCode)
        } else {
            print(#function, "Region code is nil")
            return nil
        }
    }
    
    
    func verify(phone: String) {

        authManager?.verifyPhoneNumber(phone, completionBlock: { successfully in
            
            if successfully {
                
                self.navigator.navigate(to: .authentication, presented: false)
                
            } else {
             
                print("sign in failed - \(#function)")
            }
        })
    }
}
