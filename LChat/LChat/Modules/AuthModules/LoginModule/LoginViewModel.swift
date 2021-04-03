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
    
    func login(WithVerificationCode code: String, completion: @escaping (_ isSuccess: Bool) -> ())
    func getLocaleCallingCode() -> Int?
    func verifyPhoneNumber(completion: @escaping (_ isSuccess: Bool) -> ())
}


final class LoginViewModel: LoginViewModelProtocol {
    
    //MARK: - Properties -
    
    let authService: FBAuthServiceProtocol
    let countrySelector: CountrySelectable
    
    var callingCode: String?
    var phoneNumber: String?
    
    
    //MARK: - Init -
    
    init(authService: FBAuthServiceProtocol, countrySelector: CountrySelectable) {
        
        self.authService = authService
        self.countrySelector = countrySelector
    }
    
    
    //MARK: - Methods -
    
    
    func login(WithVerificationCode code: String, completion: @escaping (_ isSuccess: Bool) -> ())  {
        
        guard let id = authService.getVerificationId(WithDeletion: true) else { assertionFailure(); return }
        
        authService.login(WithVerificationId: id, verificationCode: code) { error in
            
            if let error = error {
                
             print(error.localizedDescription)
             completion(false)
                
            } else {
                
                completion(true)
            }
        }
    }
    
    
    
    
    
    func verifyPhoneNumber(completion: @escaping (_ isSuccess: Bool) -> ()) {
        
        guard let code = self.callingCode else { completion(false); return }
        guard let phone = self.phoneNumber else { completion(false); return }
        
        
        if code != "+000" && phone.isValidPhone {
            
            authService.verify(PhoneNumber: code + phone) { result in

                switch result {

                case .failure(let error):

                    print(error)
                    completion(false)

                case .success(let id):
                    
                    if let id = id {
                        
                        self.authService.save(verificationId: id)
                        completion(true)
                        
                    } else {
                        
                        completion(false)
                    }
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
