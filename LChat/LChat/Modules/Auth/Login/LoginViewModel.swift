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
    let searcher: FBSearchable
    let countrySelector: CountrySelectable
    
    var callingCode: String?
    var phoneNumber: String?
    
    
    //MARK: - Init -
    
    init(authService: FBAuthServiceProtocol,
         countrySelector: CountrySelectable,
         searcher: FBSearchable) {
        
        self.authService = authService
        self.searcher = searcher
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
            
            let fullPhoneNumber = (code + phone).removingWhitespaces()
            
    
            self.authService.isDuplicate(fullPhoneNumber, in: .phone) { isExist in
                
                
                if isExist {
                    
                    self.authService.verify(PhoneNumber: fullPhoneNumber) { result in

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
                    
                    
                } else {
                    
                    completion(false)
                    
                }
            }
        }
    }
    
    
    
    
    private  func checkAvailabilityInDB(phone: String, completion: @escaping (Bool) -> ()) {
        
        searcher.search(phone, in: .phone) { result in
            
            if result == nil {
                
                completion(false)
                
            } else {
                
                completion(true)
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
