import UIKit
import Firebase

extension SignUpViewController: CountriesViewControllerDelegate {
    
    func viewController(_ viewController: UIViewController, didSelect country: Country) {
        
        if let code = country.callingCode {
            
            let codeWithPlus = "+" + String(code)
            authView.phoneTxtField.leftViewLabel.text = codeWithPlus
            viewModel.callingCode = codeWithPlus
        }
    }
}



extension SignUpViewController: UITextFieldDelegate {
    
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
        
        
        
        if let textField = textField as? UsernameTextField {
            
            if let maxLength = textField.maxLength {
                
                guard let text = textField.text else { return true }
                
                if text.count >= maxLength {
                    
                    textField.deleteBackward()
                }
            }
        }
        
        return true
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
    
        case is UsernameTextField:
            
            self.viewModel.username = authView.usernameTxtField.text
            
        case is PhoneNumberTextField:
            
            self.viewModel.phoneNumber = textField.text
            self.viewModel.phoneNumber = textField.text

        default:
            break
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        view.endEditing(true)
        return true
    }
}


extension SignUpViewController: VerificationViewControllerDelegate {
    
    func viewController(_ viewController: UIViewController, didConfirmCode code: String) {

        self.viewModel.signUp(WithVerificationCode: code) { isSignedUp in
         
            if isSignedUp {
                
                self.coordinator?.didFinishAuth()
                
            } else {
                
                print("Show error alert")
            }
        }
    }
}
