import UIKit


final class SignUpViewController: UIViewController {
    
    
    //MARK: - Properties -
    
    var viewModel: SignUpViewModelProtocol
    var coordinator: AuthCoordinator?
    var cardViewBottomConstraint: NSLayoutConstraint?
    let authView = AuthView()
    
    
    //MARK: - Init -
    
    init(viewModel: SignUpViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        authView.button.roundCorners(authView.button.bounds.height / 2.0)
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
            
            guard let isTakenUsername = self.viewModel.isTakenUsername.value else { return }
            
            if !isTakenUsername {
                
                
                self.viewModel.verifyPhoneNumber { isSuccess in
                    
                    if isSuccess {
                        
                        self.coordinator?.navigateToVerification()
                        self.subscribeDelegate()
                        
                    } else {

                        self.showErrorAlert()
                    }
                }
                
            } else {
                
                self.showErrorAlert()
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
        
        if let callingCode = viewModel.callingCode, let phone = viewModel.phoneNumber {
            
            guard let vc = self.navigationController?.topViewController as? VerificationViewController else { return }
            vc.delegate = self
            vc.viewModel.userPhoneNumber = callingCode + phone
        }
    }
    
    
    
    
    private func showErrorAlert() {
        
        let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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


