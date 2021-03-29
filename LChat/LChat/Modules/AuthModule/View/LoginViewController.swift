//
//  SignUpViewController.swift
//  LChat
//
//  Created by Егор on 23.03.2021.
//

import UIKit


final class LoginViewController: UIViewController {
    
    
    //MARK: - Properties -
    
    
    var viewModel: LoginViewModelProtocol
    var coordinator: AuthCoordinator?
    var cardViewBottomConstraint: NSLayoutConstraint?

    
   lazy var cardView: AuthView = {
     
        let view = AuthView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
   
    lazy var signUpButton: UIButton = {
       
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        
        button.addAction(UIAction(handler: { _ in
        
            self.coordinator?.navigateToSignUp()
        
        }), for: .touchUpInside)
        
        return button
    }()
    
    
    
    //MARK: - Init -
    
    init(viewModel: LoginViewModelProtocol) {
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
        navigationController?.navigationBar.isHidden = true
        setBackgroundImage()
        setupLayout()
        setupViewModelObserver()
        configCardView()
        
        viewModel.callingCode = cardView.phoneTxtField.leftViewLabel.text
        viewModel.phoneNumber = cardView.phoneTxtField.text!
        
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow(_:)),
                                                name: UIResponder.keyboardWillShowNotification,
                                                object: nil)
        
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                                 name: UIResponder.keyboardWillHideNotification,
                                                 object: nil)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cardView.button.roundCorners(cardView.button.bounds.height / 2.0)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        cardView.roundCorners([.topLeft, .topRight], radius: 20.0)
    }
    
    

    //MARK: - Methods -
    
    
    func configCardView() {
        
        configCardViewButtonAction()
        configPhoneTxtFieldAction()
        
        cardView.titleLabel.text = "Get Login"
        cardView.button.setTitle("Get Login", for: .normal)
        
        cardView.phoneTxtField.delegate = self
        cardView.userNameTxtField.isHidden = true
        
        if let code = viewModel.getLocaleCallingCode() {
            
            cardView.phoneTxtField.leftViewLabel.text = "+" + String(code)
        }
    }
    
    
    
    func configPhoneTxtFieldAction() {
       
        cardView.phoneTxtField.leftViewTapAction = {

            self.coordinator?.navigateToCountries()
        }
    }
    
    
    
    
    func configCardViewButtonAction() {
        
        cardView.buttonAction = {
            
            self.viewModel.login { isSuccess in
             
                if isSuccess {
                    
                    self.coordinator?.navigateToVerification()
            
                } else {
                    
                    print("TODO:  Show alert with error in LoginVC")
                }
            }
        }
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
        
       
       
    }
    
    
    
    private func setupLayout() {
        
        view.addSubviews([cardView, signUpButton])
        
        cardViewBottomConstraint = cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        cardViewBottomConstraint?.isActive = true

        NSLayoutConstraint.activate([
           
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.widthAnchor.constraint(equalTo: view.widthAnchor),
            cardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            signUpButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20.0),
            signUpButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0)
        ])
    }
}



//MARK: - Extension -


extension LoginViewController: CountriesViewControllerDelegate {
    
    func viewController(_ viewController: UIViewController, didSelect country: Country) {
                
        if let code = country.callingCode {
            self.cardView.phoneTxtField.leftViewLabel.text = "+" + String(code)
        }
    }
}



extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
                
        if textField === cardView.phoneTxtField {
                
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
        
            self.viewModel.callingCode = cardView.phoneTxtField.leftViewLabel.text
            self.viewModel.phoneNumber = textField.text
    }
}

