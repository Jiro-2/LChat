//
//  VerificationViewModel.swift
//  LChat
//
//  Created by Егор on 27.03.2021.
//

import Foundation

protocol  VerificationViewModelProtocol {
    
    var verificationCode: String? { get set }
    func login(completion: @escaping (Error?) -> ())
    func resendVerificationCode()
}


final class VerificationViewModel: VerificationViewModelProtocol {
    
    //MARK: - Properties -
    
    private var authService: FBAuthServiceProtocol?
    var verificationCode: String?
    

    //MARK: - Init -
    
    init(authService: FBAuthServiceProtocol) {
        self.authService = authService
    }
    
    
    //MARK: - Methods -
    
    
    func login(completion: @escaping (Error?) -> ()) {
        
        guard let id = authService?.getVerificationId(WithDeletion: true) else { assertionFailure(); return }
        guard let code = self.verificationCode else { assertionFailure(); return }
        
        authService?.login(WithVerificationId: id, verificationCode: code, completion: {  error in
            
            if let error = error {
                
                completion(error)
                
            } else {
                
                completion(nil)
            }
        })
    }
    
    
    
    func resendVerificationCode() {
        
        authService?.verify(PhoneNumber: "", completion: { result in
            
            
            
        })
    }
}
