import UIKit


final class LoginViewController: UIViewController {
    
    
    //MARK: - Properties -
    
    var viewModel: LoginViewModelProtocol
    var coordinator: AuthCoordinator?
    var cardViewBottomConstraint: NSLayoutConstraint?

    
   lazy var authView: AuthView = {
     
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
        configCardView()
        
        viewModel.callingCode = authView.phoneTxtField.leftViewLabel.text
        viewModel.phoneNumber = authView.phoneTxtField.text!
        
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow(_:)),
                                                name: UIResponder.keyboardWillShowNotification,
                                                object: nil)
        
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                                 name: UIResponder.keyboardWillHideNotification,
                                                 object: nil)
        
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
    
    
    func configCardView() {
        
        configCardViewButtonAction()
        configPhoneTxtFieldAction()
        
        authView.titleLabel.text = "Get Login"
        authView.button.setTitle("Get Login", for: .normal)
        
        authView.phoneTxtField.delegate = self
        authView.usernameTxtField.isHidden = true
        
        if let code = viewModel.getLocaleCallingCode() {
            
            authView.phoneTxtField.leftViewLabel.text = "+" + String(code)
        }
    }
    
    
    
    func configPhoneTxtFieldAction() {
       
        authView.phoneTxtField.leftViewTapAction = {

            self.coordinator?.navigateToCountries()
        }
    }
    
    
    
    
    func configCardViewButtonAction() {
        
        authView.buttonAction = {
            
            self.viewModel.verifyPhoneNumber { isSuccess in
             
                if isSuccess {
                    
                    self.coordinator?.navigateToVerification()
                    self.subscribeDelegate()
            
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
    
    
    
    
    private func subscribeDelegate() {
        
        guard let vc = self.navigationController?.topViewController as? VerificationViewController else { return }
        vc.delegate = self
    }
    
    
    
    private func setupLayout() {
        
        view.addSubviews([authView, signUpButton])
        
        cardViewBottomConstraint = authView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        cardViewBottomConstraint?.isActive = true

        NSLayoutConstraint.activate([
           
            authView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authView.widthAnchor.constraint(equalTo: view.widthAnchor),
            authView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            signUpButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20.0),
            signUpButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0)
        ])
    }
}
