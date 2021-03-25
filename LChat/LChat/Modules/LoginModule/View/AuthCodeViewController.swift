//
//  ConfirmPhoneNumberViewController.swift
//  LingoChat
//
//  Created by Егор on 06.01.2021.
//


import UIKit

protocol AuthCodeViewControllerDelegate: class {
    
    func getUserRegistrationData() -> (firstName: String, lastName: String, phone: String)?
}


class AuthCodeViewController: UIViewController {
    
    //MARK: - Properties
    
    var viewModel: AuthCodeViewModelProtocol?
    var verificationCode = ""
    weak var delegate: AuthCodeViewControllerDelegate?
    
    //layout
    
    private var sharedConstraints: [NSLayoutConstraint] = []
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []
    private var regxRegConstraints: [NSLayoutConstraint] = []
    
    //MARK: Subviews
    
    //TextFields
    
    private let firstCodeTextField = UITextField(borderColor: .black, borderWidth: 2.0, tintColor: .clear, font: UIFont(name: "KohinoorTelugu-Light", size: 30.0), cornerRadius: 10.0)
    private let secondCodeTextField = UITextField(borderColor: .black, borderWidth: 2.0, tintColor: .clear, font: UIFont(name: "KohinoorTelugu-Light", size: 30.0), cornerRadius: 10.0)
    private let thirdCodeTextField = UITextField(borderColor: .black, borderWidth: 2.0, tintColor: .clear, font: UIFont(name: "KohinoorTelugu-Light", size: 30.0), cornerRadius: 10.0)
    private let firthCodeTextField = UITextField(borderColor: .black, borderWidth: 2.0, tintColor: .clear, font: UIFont(name: "KohinoorTelugu-Light", size: 30.0), cornerRadius: 10.0)
    private let fifthCodeTextField = UITextField(borderColor: .black, borderWidth: 2.0, tintColor: .clear, font: UIFont(name: "KohinoorTelugu-Light", size: 30.0), cornerRadius: 10.0)
    private let sixthCodeTextField = UITextField(borderColor: .black, borderWidth: 2.0, tintColor: .clear, font: UIFont(name: "KohinoorTelugu-Light", size: 30.0), cornerRadius: 10.0)
    
    
    private var txtFieldsStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 5.0
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    
    //Image
    
    private let image: UIImageView = {
        
        let imageView = UIImageView(image: UIImage(named: "shieldMan"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    
    //Label
    
    private let explainLabel = UILabel(text: "Enter the 6-digit code sent to your phone number", fontSize: 17.0, textColor: .black)
    
    
    //Button
    
    private let confirmButton: UIButton = {
        
        let confirmButton = UIButton()
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.layer.masksToBounds = false
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: "KohinoorTelugu-Medium", size: 20.0)
        confirmButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        confirmButton.layer.cornerRadius = 20.0
        confirmButton.titleLabel?.textColor = .white
        confirmButton.layer.shadowColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        confirmButton.layer.shadowOpacity = 0.3
        confirmButton.layer.shadowRadius = 5.0
        confirmButton.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        confirmButton.addTarget(self, action: #selector(confirmBtnDidTap), for: .touchUpInside)
        
        return confirmButton
    }()
    
    
    
    //MARK: - Init
    
    convenience init(viewModel: AuthCodeViewModelProtocol?) {
        self.init()
        self.viewModel = viewModel
    }
    
    
    
    //MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubviews([image, explainLabel, txtFieldsStackView, confirmButton])
        
        txtFieldsStackView.addArrangedViews([firstCodeTextField, secondCodeTextField,
                                             thirdCodeTextField, firthCodeTextField,
                                             fifthCodeTextField, sixthCodeTextField])
        
        
        setupConstraints()
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
        subscribeDelegates()
        addTargetForTxtFields()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addUnderLinesFor(textFields: [firstCodeTextField, secondCodeTextField,
                                      thirdCodeTextField, firthCodeTextField,
                                      fifthCodeTextField, sixthCodeTextField])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        confirmButton.layer.cornerRadius = confirmButton.frame.size.height * 0.5
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        layoutTrait(traitCollection: traitCollection)
    }
    
    
    
    //MARK: - Private
    
    
    
    private func subscribeDelegates() {
        
        firstCodeTextField.delegate = self
        secondCodeTextField.delegate = self
        thirdCodeTextField.delegate = self
        firthCodeTextField.delegate = self
        fifthCodeTextField.delegate = self
        sixthCodeTextField.delegate = self
        
    }
    
    
    private func addTargetForTxtFields() {
        
        firstCodeTextField.addTarget(self, action: #selector(codeDidEnter(_:)), for: .editingChanged)
        secondCodeTextField.addTarget(self, action: #selector(codeDidEnter(_:)), for: .editingChanged)
        thirdCodeTextField.addTarget(self, action: #selector(codeDidEnter(_:)), for: .editingChanged)
        firthCodeTextField.addTarget(self, action: #selector(codeDidEnter(_:)), for: .editingChanged)
        fifthCodeTextField.addTarget(self, action: #selector(codeDidEnter(_:)), for: .editingChanged)
        sixthCodeTextField.addTarget(self, action: #selector(codeDidEnter(_:)), for: .editingChanged)
    }
    
    
    @objc
    private func codeDidEnter(_ textField: UITextField) {
        
        
        if  textField.text?.count == 1 {
            
            switch textField {
            
            case firstCodeTextField:
                
                verificationCode += textField.text!
                secondCodeTextField.becomeFirstResponder()
                
            case secondCodeTextField:
                
                verificationCode += textField.text!
                thirdCodeTextField.becomeFirstResponder()
                
            case thirdCodeTextField:
                
                verificationCode += textField.text!
                firthCodeTextField.becomeFirstResponder()
                
            case firthCodeTextField:
                
                verificationCode += textField.text!
                fifthCodeTextField.becomeFirstResponder()
                
            case fifthCodeTextField:
                
                verificationCode += textField.text!
                sixthCodeTextField.becomeFirstResponder()
                
            case sixthCodeTextField:
                
                verificationCode += textField.text!
                view.endEditing(true)
            default:
                break
            }
        }
    }
    
    
    @objc
    private func confirmBtnDidTap() {
        
        if verificationCode.count == 6 {
            
                viewModel?.confirmVerificationCode(verificationCode)
        }
    }
    
    
    
    
    private func addUnderLinesFor(textFields: [UITextField]) {
        textFields.forEach { txtField in
            
            if let cgColor = txtField.layer.borderColor {
                txtField.useUnderline(withColor: UIColor(cgColor: cgColor), thickness: txtField.layer.borderWidth)
            } else {
                txtField.useUnderline(withColor: .black, thickness: txtField.layer.borderWidth)
            }
        }
    }
    
    
    //MARK: Layout
    
    
    private func setupConstraints() {
        
        
        sharedConstraints.append(contentsOf: [
            
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            explainLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            
            txtFieldsStackView.topAnchor.constraint(equalTo: explainLabel.bottomAnchor, constant: 10.0),
            txtFieldsStackView.centerXAnchor.constraint(equalTo: explainLabel.centerXAnchor),
            
            confirmButton.topAnchor.constraint(equalTo: txtFieldsStackView.bottomAnchor, constant: 15.0),
            confirmButton.widthAnchor.constraint(equalTo: txtFieldsStackView.widthAnchor, multiplier: 0.7),
            confirmButton.centerXAnchor.constraint(equalTo: txtFieldsStackView.centerXAnchor),
            confirmButton.heightAnchor.constraint(equalTo: txtFieldsStackView.heightAnchor, multiplier: 0.8)
        ])
        
        
        portraitConstraints.append(contentsOf: [
            
            image.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            image.widthAnchor.constraint(equalTo: view.widthAnchor),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            explainLabel.topAnchor.constraint(equalTo: image.bottomAnchor),
            explainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            
            txtFieldsStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            txtFieldsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            
        ])
        
        
        landscapeConstraints.append(contentsOf: [
            
            image.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            image.heightAnchor.constraint(equalTo: view.heightAnchor),
            image.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            
            explainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
            explainLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor),
            
            txtFieldsStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            txtFieldsStackView.widthAnchor.constraint(equalTo: explainLabel.widthAnchor)
        ])
        
        
        regxRegConstraints.append(contentsOf: [
            
            image.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            explainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            explainLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10.0),
            
            txtFieldsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            txtFieldsStackView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            
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


//MARK: - Extension



//MARK: Delegate


extension AuthCodeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = UIColor.lightGray.cgColor
    }
}


