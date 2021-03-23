//
//  SignInViewController.swift
//  LingoChat
//
//  Created by Егор on 06.01.2021.
//

import UIKit
import FirebaseDatabase


class SignInViewController: UIViewController {
    
    
    //MARK: Properties
    
    var viewModel: SigninViewModelProtocol?
    
    
    private var sharedConstraints: [NSLayoutConstraint] = []
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []
    private var regxRegConstraints: [NSLayoutConstraint] = []
    
    
  
    //MARK: - Subviews
    
    
    
    //TextField
    
    private let phoneTextField: PhoneNumberTextField = {
        
        let txtField = PhoneNumberTextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor.lightGray.cgColor
        txtField.clipsToBounds = true
        txtField.countryLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        txtField.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        txtField.font = UIFont(name: "KohinoorTelugu-Medium", size: 20.0)
        
        return txtField
    }()
    
    
    //Labels
    
    private let titleLabel = UILabel(text: "Sign In", fontSize: 30.0, textColor: .black)
    private let phoneNumberLabel = UILabel(text: "Phone Number", fontSize: 17.0, textColor: .black)
    
    
    
    //Buttons
    
    private let signInButton: UIButton = {
        
        let signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.layer.masksToBounds = false
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.titleLabel?.font = UIFont(name: "KohinoorTelugu-Medium", size: 25.0)
        signInButton.layer.cornerRadius = 20.0
        signInButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        signInButton.titleLabel?.textColor = .white
        signInButton.layer.shadowColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        signInButton.layer.shadowOpacity = 0.3
        signInButton.layer.shadowRadius = 5.0
        signInButton.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        signInButton.addTarget(self, action: #selector(signInBtnTapped), for: .touchUpInside)
        
        return signInButton
    }()
    
    
    
    //MARK:  - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        view.addSubviews([titleLabel, phoneTextField, phoneNumberLabel, signInButton])
        
        setupConstraints()
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
        subscribeDelegates()
        setLocaleCallingCode()
    }
    

    
    override func viewDidLayoutSubviews() {
        
        phoneTextField.roundCorners(phoneTextField.bounds.size.height / 2.0)
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        layoutTrait(traitCollection: traitCollection)
    }
    
    
    
    //MARK: - Private
    
    @objc
    private func signInBtnTapped() {
        
        if let callingCode = phoneTextField.countryLabel.text, let number = phoneTextField.text {
        
            let numberWithoutSpace = number.components(separatedBy: " ").joined()
            
            viewModel?.verify(phone: callingCode + numberWithoutSpace)
            
            UserRegisterData.shared.phone = PhoneNumber(callingCode: callingCode, number: numberWithoutSpace)
        }
    }
    
    
    
    private func subscribeDelegates() {
        
        phoneTextField.leftViewDelegate = self
        phoneTextField.delegate = self
    }
    
    
    
    private func setLocaleCallingCode() {
        
        let localeCountry = viewModel?.getLocaleCountry()
        
        if let code = localeCountry?.callingCode {
            phoneTextField.countryLabel.text = "+\(code)"
        }
    }
    
    //MARK: Layout
    

    private func setupConstraints() {
        
        
        sharedConstraints.append(contentsOf: [
        
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            phoneNumberLabel.centerYAnchor.constraint(equalTo: phoneTextField.topAnchor),
            phoneNumberLabel.leftAnchor.constraint(equalTo: phoneTextField.leftAnchor, constant: 25.0),
            
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
        
        
        portraitConstraints.append(contentsOf: [
        
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 4),
            
            
            phoneTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0),
            phoneTextField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            phoneTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            phoneTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        
            signInButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 30.0),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            signInButton.heightAnchor.constraint(equalTo: phoneTextField.heightAnchor, multiplier: 1.2)
            
            
        
        ])
        
        
        landscapeConstraints.append(contentsOf: [
        
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0),
            
            phoneTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0),
            phoneTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            phoneTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            phoneTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0),
            
            signInButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            signInButton.heightAnchor.constraint(equalTo: phoneTextField.heightAnchor, multiplier: 1.2)

        ])
        
        
        regxRegConstraints.append(contentsOf: [
        
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.15),
            
            phoneTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            phoneTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            phoneTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50.0),
            phoneTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.0),
            
            signInButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor),
            signInButton.widthAnchor.constraint(equalTo: phoneTextField.widthAnchor, multiplier: 1.1),
            signInButton.heightAnchor.constraint(equalTo: phoneTextField.heightAnchor)
        ])
    }
    
    
    
    private func layoutTrait(traitCollection: UITraitCollection) {
        
        if !sharedConstraints[0].isActive {
            
            NSLayoutConstraint.activate(sharedConstraints)
        }
        
        
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            
            if landscapeConstraints[0].isActive {
                
                NSLayoutConstraint.deactivate(landscapeConstraints)
            }
            NSLayoutConstraint.activate(portraitConstraints)
            
        } else if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .compact {

            if portraitConstraints[0].isActive {
                
                NSLayoutConstraint.deactivate(portraitConstraints)
            }
            
            NSLayoutConstraint.activate(landscapeConstraints)
            
        } else {
            
            NSLayoutConstraint.activate(regxRegConstraints)
        }
    }
}


//MARK: - Extensions



//MARK: Delegates

extension SignInViewController: PhoneNumberTextFieldDelegate {
    
    func leftViewTapped() {
        
        viewModel?.navigator.navigate(to: .selectionCountry, presented: true)
    }
}


extension SignInViewController: CountriesViewControllerDelegate {
    
    func selectCountry(_ country: Country) {
        
        if let code = country.callingCode {
            self.phoneTextField.countryLabel.text = "+\(code)"
        }
    }
}


extension SignInViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = #colorLiteral(red: 0.9076607823, green: 0.416919142, blue: 0.6715705991, alpha: 1)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField === phoneTextField {
            
            if let text = textField.text {
                
                if !string.isEmpty {
                    
                    if text.count == 2 || text.count == 6 || text.count == 9 {
                        
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
}

