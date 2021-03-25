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
    var cardViewBottomConstraint: NSLayoutConstraint?

    
   lazy var cardView: AuthFormView = {
     
        let view = AuthFormView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
   
    
    lazy var logInButton: UIButton = {
       
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        
        button.addAction(UIAction(handler: { _ in
        
            self.viewModel.navigateToLogin()
        
        }), for: .touchUpInside)
        
        return button
    }()
    
    
    
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
        navigationController?.navigationBar.isHidden = true
        setBackgroundImage()
        setupLayout()
        configCardViewButtonAction()
        setupViewModelObserver()
        cardView.phoneTxtField.delegate = self
        cardView.userNameTxtField.delegate = self
        
        cardView.titleLabel.text = "Sign Up"
        cardView.button.setTitle("Signup Now", for: .normal)
       
        
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
    
    func configCardViewButtonAction() {
        
        cardView.buttonAction = {
            
            print("Did tap")
        }
    }
    
    
    
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            cardViewBottomConstraint?.constant = -frame.height
            animateCardView()
        }
    }
    
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        cardViewBottomConstraint?.constant = 0
        animateCardView()
    }
    
    
    
    func animateCardView() {
        
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
        
        view.addSubviews([cardView, logInButton])
        
        cardViewBottomConstraint = cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        cardViewBottomConstraint?.isActive = true

        NSLayoutConstraint.activate([
           
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.widthAnchor.constraint(equalTo: view.widthAnchor),
            cardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            logInButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20.0),
            logInButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            
        ])
    }
}


//MARK: - Extension -


extension SignUpViewController: UITextFieldDelegate {
    
    
    
    
    
}
