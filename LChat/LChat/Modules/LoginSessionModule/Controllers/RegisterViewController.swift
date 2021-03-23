//
//  RegistrationViewController.swift
//  LingoChat
//
//  Created by Егор on 04.01.2021.
//

import UIKit

class RegisterViewController: UIViewController {
    
    //MARK: Properties
    
    private var sharedConstraints: [NSLayoutConstraint] = []
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []
    private var regxRegConstraints: [NSLayoutConstraint] = []
    
    
    var viewModel: RegisterViewModelProtocol?
    
    //MARK: - Subviews
    
    
    //TextFields
    
    private let firstNameTextField = UITextField(borderWidth: 1.0, borderColor: .lightGray, cornerRadius: 20.0, leftPadding: 10.0)
    private let lastNameTextField = UITextField(borderWidth: 1.0, borderColor: .lightGray, cornerRadius: 20.0, leftPadding: 10.0)

    
    //Labels
    
    private let titleLabel = UILabel(text: "Register", fontSize: 30.0, textColor: .black)
    private let firstNameLabel = UILabel(text: "First Name", fontSize: 17.0, textColor: .black)
    private let lastNameLabel = UILabel(text: "Last Name", fontSize: 17.0, textColor: .black)    
    
    //Buttons
    
    private let registerButton: UIButton = {
        let registerBtn = UIButton()
        registerBtn.translatesAutoresizingMaskIntoConstraints = false
        registerBtn.layer.masksToBounds = false
        registerBtn.setTitle("Register", for: .normal)
        registerBtn.titleLabel?.font = UIFont(name: "KohinoorTelugu-Medium", size: 25.0)
        registerBtn.layer.cornerRadius = 20.0
        registerBtn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        registerBtn.titleLabel?.textColor = .white
        registerBtn.layer.shadowColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        registerBtn.layer.shadowOpacity = 0.3
        registerBtn.layer.shadowRadius = 5.0
        registerBtn.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        registerBtn.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        return registerBtn
    }()
    
    

    
    //MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        
        view.addSubviews([titleLabel, firstNameTextField, lastNameTextField, firstNameLabel,
                          lastNameLabel, registerButton])
        
        setupConstraints()
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
        subscribeDelegates()
        
    }
    
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        layoutTrait(traitCollection: traitCollection)
    }
    
    
    //MARK: - Private
    
    
    @objc
    private func registerButtonTapped() {
        
        if let firstName = firstNameTextField.text,
           let lastName = lastNameTextField.text {
            
            viewModel?.registerUser(with: firstName, lastName: lastName)
           
        } else {
            
            print(#function, "Input is nil")
        }
    }
    
    
    
    private func subscribeDelegates() {
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
    }
    
    
    //MARK: Layout
    
    private func setupConstraints() {
        
        sharedConstraints.append(contentsOf: [
        
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            firstNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            
            firstNameLabel.leftAnchor.constraint(equalTo: firstNameTextField.leftAnchor, constant: 20.0),
            firstNameLabel.centerYAnchor.constraint(equalTo: firstNameTextField.topAnchor),
            
            lastNameTextField.widthAnchor.constraint(equalTo: firstNameTextField.widthAnchor),
            lastNameTextField.centerYAnchor.constraint(equalTo: firstNameTextField.centerYAnchor),
            lastNameTextField.heightAnchor.constraint(equalTo: firstNameTextField.heightAnchor),
            
            lastNameLabel.centerYAnchor.constraint(equalTo: lastNameTextField.topAnchor),
            lastNameLabel.leftAnchor.constraint(equalTo: lastNameTextField.leftAnchor, constant: 20.0),
            
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 30.0),
            registerButton.heightAnchor.constraint(equalTo: firstNameTextField.heightAnchor, multiplier: 1.2),
            
        ])
        
        
        portraitConstraints.append(contentsOf: [
        
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.size.height * 0.2),
            
            firstNameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15.0),
            firstNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15.0),
            firstNameTextField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            
            lastNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15.0),
            
            registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),

        ])
        
        
        landscapeConstraints.append(contentsOf: [
        
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10.0),
            
            firstNameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15.0),
            firstNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            firstNameTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            lastNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15.0),

            registerButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
        ])
        
        
        regxRegConstraints.append(contentsOf: [
        
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.size.height * 0.2),
            
            firstNameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: view.bounds.size.width * 0.07),
            firstNameTextField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.05),
            firstNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.0),
            
            lastNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -view.bounds.size.width * 0.07),
            
            registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
        
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

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
}
