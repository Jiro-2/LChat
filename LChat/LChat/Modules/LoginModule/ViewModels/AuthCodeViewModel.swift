//
//  AuthCodeViewModel.swift
//  LingoChat
//
//  Created by Егор on 05.02.2021.
//

import Foundation

protocol AuthCodeViewModelProtocol {
    
    func confirmVerificationCode(_ code: String)
    func showRegisterVC()
}


class AuthCodeViewModel: AuthCodeViewModelProtocol {
    
    var authManager: FBAuthManagerProtocol?
    var navigator: LoginNavigator?
    
    convenience init(authManager: FBAuthManagerProtocol?, navigator: LoginNavigator?) {
        self.init()
        self.authManager = authManager
        self.navigator = navigator
    }
    
    
    
    func confirmVerificationCode(_ code: String) {
        
        if code.count == 6 {
            
            guard let id = UserDefaults.standard.string(forKey: "verificationID") else { return }
            
            authManager?.signin(WithCode: code, verificationID: id, completionBlock: { successfully in
                
                if successfully {
                    
                    print("Confirm Verification code successed")
                    
//                    self.authManager?.checkPresenceUserInDataBase({ isPresence in
//
//                        if isPresence {
//
//                            //Если пользователь с идентиф существует в базе то зайти в профиль далее
//                            print("Если пользователь с идентиф существует в базе то зайти в профиль далее")
//
//                        } else {
//                            // усли польз не существует то перейти на экран регистраци
//                            print("усли польз не существует то перейти на экран регистраци")
//                          //  self.navigator?.navigate(to: .register, presented: false)
//                        }
//                    })
                    
                } else {
                    
                    print("Confirm Verification failed")
                }
            })
        }
        UserDefaults.standard.removeObject(forKey: "verificationID")
    }
    
    
    func showRegisterVC() {
        
        self.navigator?.navigate(to: .register, presented: false)
    }
}
