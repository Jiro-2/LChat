//
//  LoginViewController+Delegates.swift
//  LChat
//
//  Created by Егор on 02.04.2021.
//

import UIKit


extension LoginViewController: CountriesViewControllerDelegate {
    
    func viewController(_ viewController: UIViewController, didSelect country: Country) {
                
        if let code = country.callingCode {
            self.authView.phoneTxtField.leftViewLabel.text = "+" + String(code)
        }
    }
}



extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
                
        if textField === authView.phoneTxtField {
                
                if let text = textField.text {
                    
                    if !string.isEmpty {
                        
                        if text.count == 3 || text.count == 7 {
                            
                            textField.text! += " "
                            
                        } else if text.count == 11 {
                            
                            textField.text! += string
                            view.endEditing(true)
                        }
                    }
                }
            }
            
            return true
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
            self.viewModel.callingCode = authView.phoneTxtField.leftViewLabel.text
            self.viewModel.phoneNumber = textField.text
    }
}



extension LoginViewController: VerificationViewControllerDelegate {
    
    func viewController(_ viewController: UIViewController, didConfirmCode code: String) {

        self.viewModel.login(WithVerificationCode: code) { isLoggedIn in
            
            if isLoggedIn {
                
                
                print("Navigate to chat")
            } else {
                
                print("Alert with error")
                
            }
        }
    }
}
