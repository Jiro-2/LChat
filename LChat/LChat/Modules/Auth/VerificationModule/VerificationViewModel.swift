import Foundation

protocol  VerificationViewModelProtocol {
    
    var verificationCode: String? { get set }
    var userPhoneNumber: String? { get set }
  //  func login(completion: @escaping (Error?) -> ())
    func resendVerificationCode()
}


final class VerificationViewModel: VerificationViewModelProtocol {
    
    //MARK: - Properties -
    
    private var authService: FBAuthServiceProtocol?
    var verificationCode: String?
    var userPhoneNumber: String?
    

    //MARK: - Init -
    
    init(authService: FBAuthServiceProtocol) {
        self.authService = authService
    }
    
    
    //MARK: - Methods -
    
    
//    func login(completion: @escaping (Error?) -> ()) {
//
//        guard let id = authService?.getVerificationId(WithDeletion: true) else { assertionFailure(); return }
//        guard let code = self.verificationCode else { assertionFailure(); return }
//
//        authService?.login(WithVerificationId: id, verificationCode: code, completion: {  error in
//
//            if let error = error {
//
//                completion(error)
//
//            } else {
//
//                completion(nil)
//            }
//        })
//    }
    
    
    
    func resendVerificationCode() {
        
        guard let phone = userPhoneNumber else { assertionFailure(); return }
        
        authService?.verify(PhoneNumber: phone, completion: { result in
            
            switch result {
            
            case .success(let verificationId):
                
                guard let id = verificationId else { assertionFailure(); return }
                self.authService?.save(verificationId: id)
                                
            case .failure(let error):
                
                assertionFailure(error.localizedDescription)
            }
        })
    }
}
