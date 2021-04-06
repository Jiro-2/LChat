//
//  SignUpViewController.swift
//  LChat
//
//  Created by Егор on 25.03.2021.
//

import UIKit


class SignUpViewController: UIViewController {
    
    
    //MARK: - Properties -
    
    var viewModel: SignUpViewModelProtocol
    var coordinator: AuthCoordinator?
    var cardViewBottomConstraint: NSLayoutConstraint?
    
    lazy var authView = AuthView()
    
    
    //MARK: - Init -
    
    init(viewModel: SignUpViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.isHidden = false
        
        setBackgroundImage()
        setupLayout()
        setupViewModelObserver()
        configCardView()
        addUsernameTxtFieldAction()
        
        
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow(_:)),
                                                name: UIResponder.keyboardWillShowNotification,
                                                object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        viewModel.callingCode = authView.phoneTxtField.leftViewLabel.text
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        authView.button.roundCorners(authView.button.bounds.height / 2.0)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        authView.roundCorners([.topLeft, .topRight], radius: 20.0)
    }
    
    
    
    //MARK: - Methods -
    
    
    private func configCardView() {
        
        configCardViewButtonAction()
        configPhoneTxtFieldAction()
        
        authView.phoneTxtField.delegate = self
        authView.usernameTxtField.delegate = self
        authView.usernameTxtField.maxLength = 10
        
        authView.titleLabel.text = "Sign Up"
        authView.button.setTitle("Signup Now", for: .normal)
        
        
        if let code = viewModel.getLocaleCallingCode() {
            
            authView.phoneTxtField.leftViewLabel.text = "+" + String(code)
        }
    }
    
    
    
    private func configPhoneTxtFieldAction() {
        
        authView.phoneTxtField.leftViewTapAction = {
            
            self.coordinator?.navigateToCountries()
        }
    }
    
    
    
    
    private  func configCardViewButtonAction() {
        
        authView.buttonAction = {
         
            self.viewModel.verifyPhoneNumber { isSuccess in
                
                if isSuccess {
                 
                    self.coordinator?.navigateToVerification()
                    self.subscribeDelegate()
                    
                } else {
                    
                    print("TODO:  Show alert with error in SignUpVC")
                }
            }
        }
    }
    
    
    
    
    private func addUsernameTxtFieldAction() {
        
        authView.usernameTxtField.addAction(UIAction(handler: { _ in
            
            if let text = self.authView.usernameTxtField.text {
                
                if text.count >= 3 {
                    
                    self.viewModel.checkDuplicate(username: text)
                    
                    if let rightView = self.authView.usernameTxtField.rightView {
                        
                        if rightView.isHidden {
                            rightView.isHidden = false
                        }
                    }
                }
                
                
                if text.count < 3 {
                    
                    if let rightView = self.authView.usernameTxtField.rightView {
                        
                        if !rightView.isHidden {
                            rightView.isHidden = true
                        }
                    }
                    
                }
            }
            
        }), for: .editingChanged)
    }
    
    
    
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            cardViewBottomConstraint?.constant = -frame.height
            
            UIView.animate(withDuration: 0.5) {
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        
        cardViewBottomConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.5) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    private func setBackgroundImage() {
        
        let image = UIImage(named: "forestAndRoad")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        view.insertSubview(imageView, at: 0)
    }
    
    
    
    
    private func setupViewModelObserver() {
        
        viewModel.isTakenUsername.bind { isTaken in
            
            guard let isTaken = isTaken else { return }
            
            if isTaken {
                
                self.authView.usernameTxtField.changeRightView(type: .xMark)
                
            } else {
                
                self.authView.usernameTxtField.changeRightView(type: .checkMark)
            }
        }
    }
    
    
    private func subscribeDelegate() {
        
        guard let vc = self.navigationController?.topViewController as? VerificationViewController else { return }
        vc.delegate = self
    }
    
    
    
    private func setupLayout() {
        
        authView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([authView])
        
        cardViewBottomConstraint = authView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        cardViewBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            
            authView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authView.widthAnchor.constraint(equalTo: view.widthAnchor),
            authView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
        ])
    }
}


