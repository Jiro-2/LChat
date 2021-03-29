//
//  AuthorizationViewModel.swift
//  LChat
//
//  Created by Егор on 24.03.2021.
//

import Foundation



protocol LoginViewModelProtocol {
    
    var callingCode: String? { get set }
    var phoneNumber: String? { get set }
    
    func getLocaleCallingCode() -> Int?
    func login(completion: @escaping (_ isSuccess: Bool) -> ())
}


final class LoginViewModel: LoginViewModelProtocol {
    
    //MARK: - Properties -
    
    let loginService: FBLoginServiceProtocol
    let countrySelector: CountrySelectable
    
    var callingCode: String?
    var phoneNumber: String?
    
    
    //MARK: - Init -
    
    init(loginService: FBLoginServiceProtocol, countrySelector: CountrySelectable) {
        self.loginService = loginService
        self.countrySelector = countrySelector
    }
    
    
    //MARK: - Methods -
    
    func login(completion: @escaping (_ isSuccess: Bool) -> ()) {
        
        guard let code = self.callingCode else { completion(false); return }
        guard let phone = self.phoneNumber else { completion(false); return }
        
        
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
}
