//
//  SignUpViewModel.swift
//  LChat
//
//  Created by Егор on 25.03.2021.
//

import Foundation

protocol SignUpViewModelProtocol {
    
    var callingCode: String? { get set }
    var phoneNumber: String? { get set }
    var username: String? { get set }
    var isTakenUsername: Bindable<Bool> { get }
    
    func signUp(WithVerificationCode code: String, completion: @escaping (_ isSuccess: Bool) -> ())
    func verifyPhoneNumber(completion: @escaping (_ isSuccess: Bool) -> ())
    func getLocaleCallingCode() -> Int?
    func checkDuplicate(username: String)
}


final class SignUpViewModel: SignUpViewModelProtocol {
    
    
    //MARK: - Properties -
    
    private let countrySelector: CountrySelectable
    private let authService: FBAuthServiceProtocol
    
    var isTakenUsername = Bindable<Bool>()
    var callingCode: String?
    var phoneNumber: String?
    var username: String?
    
    //MARK: - Init -
    
    init(countrySelector: CountrySelectable, authService: FBAuthServiceProtocol) {
        
        self.countrySelector = countrySelector
        self.authService = authService
    }
    
    
    //MARK: - Methods -
    
    
    func signUp(WithVerificationCode code: String, completion: @escaping (_ isSuccess: Bool) -> ()) {
        
        
        guard let callingCode = self.callingCode,
              let phone = self.phoneNumber,
              let username = self.username,
              let id = self.authService.getVerificationId(WithDeletion: true)
        else { assertionFailure(); return }
        
        if callingCode != "+000" && phone.isValidPhone {
            
            let fullPhoneNumber = (callingCode + phone).removingWhitespaces()
            
            
            authService.signUp(WithVerificationId: id,
                               verificationCode: code,
                               username: username,
                               phoneNumber: fullPhoneNumber) { error in
                
                if let error = error {
                    
                    print(error.localizedDescription)
                    completion(false)
                    
                } else {
                    
                    completion(true)
                }
            }
        }
    }
    
    
    
    
    
    
    func verifyPhoneNumber(completion: @escaping (_ isSucces: Bool) -> ()) {
        
        guard let code = self.callingCode else { return }
        guard let phone = self.phoneNumber else { return }
        
        
        if code != "+000" && phone.isValidPhone {
            
            authService.verify(PhoneNumber: code + phone) { result in
                
                switch result {
                
                case .failure(let error):
                    
                    print(error.localizedDescription)
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
    
    
    
    
    func checkDuplicate(username: String) {
        
        authService.checkDuplicate(username: username) { [weak self] isDuplicate in
            
            self?.isTakenUsername.value = isDuplicate
        }
    }
    
    
    
    
    func getLocaleCallingCode() -> Int? {
        
        var code: Int?
        
        if let localeCode = Locale.current.regionCode?.uppercased() {
            
            let country = countrySelector.getCountry(localeCode)
            code = country.callingCode
        }
        
        return code
    }
}
