//
//  RegisterViewModel.swift
//  LingoChat
//
//  Created by Егор on 31.01.2021.
//

import Foundation

protocol RegisterViewModelProtocol {
    
    func showCountriesVC()
    func getLocaleCountry() -> Country?
    func registerUser(with name: String, lastName: String)
}


class RegisterViewModel: RegisterViewModelProtocol {
    
    //MARK: - Properties
    
    private var navigator: LoginNavigator
    var countrySelector: CountrySelectable?
    var authManager: FBAuthManagerProtocol?
    
    //MARK: - Init
    
    init(navigator: LoginNavigator) {
        
        self.navigator = navigator
    }
    
    
    //MARK: - Methods
    
    
    func registerUser(with name: String, lastName: String) {
        
        if !UserRegisterData.shared.phone.fullPhoneNumber.isEmpty {
            
            self.authManager?.checkPresenceUserInDataBase({ isPresence in
                
                
                if isPresence {
                    
                    print("User exist in Database")
                    
                } else {
                    
                    self.authManager?.registerUser(with: name, lastName: lastName, phoneNumber: UserRegisterData.shared.phone.fullPhoneNumber, completionBlock: { isRegistered in
                        
                        
                        if isRegistered {
                            
                            print("Registration user was successful")
                            
                        } else {
                            
                            print("User registration failed")
                        }
                    })
                }
            })
        } else {
            
            self.authManager?.checkPresenceUserInDataBase({ [weak self] isPresence in
                
                guard let self = self else { return }
                
                if isPresence {
        
                    print("User exist in Database")
                    
                } else {
                    
                    guard let phoneNumber = self.authManager?.getUserPhone() else { return }
                    
                    self.authManager?.registerUser(with: name, lastName: lastName, phoneNumber: phoneNumber, completionBlock: { isRegistered in
                        
                        if isRegistered {
                            
                            print("Registration user was successful")
                            
                        } else {
                            print("User registration failed")
                        }
                    })
                }
            })
        }
    }
    
    
    
    func getLocaleCountry() -> Country? {
        
        if let regionCode = Locale.current.regionCode?.uppercased() {
            
            return countrySelector?.getCountry(regionCode)
        } else {
            print(#function, "Region code is nil")
            return nil
        }
    }
    
    
    func showCountriesVC() {
        navigator.navigate(to: .selectionCountry, presented: true)
    }
}



