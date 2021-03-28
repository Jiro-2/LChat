//
//  VerificationViewController.swift
//  LChat
//
//  Created by Егор on 27.03.2021.
//

import UIKit

class VerificationViewController: UIViewController {
    
    //MARK: - Properties -
    
    var viewModel: VerificationViewModelProtocol
    var coordinator: AuthCoordinator?
    
    //Subviews
    
    private lazy var titleLabel: UILabel = {
        
        let label = UILabel(text: "Verification Security Code",
                            font: UIFont.systemFont(ofSize: 40.0, weight: .bold),
                            textColor: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    
    private let explainLabel: UILabel = {
        
        let label = UILabel(text: "Enter the 6-digit code sent to your phone number", font: UIFont.systemFont(ofSize: 18.0), textColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    
    private let firstCodeTextField = UITextField(backgroundColor: #colorLiteral(red: 0.9493990541, green: 0.9533054233, blue: 0.9598917365, alpha: 1), cornerRadius: 10.0, textAlignment: .center)
    private let secondCodeTextField = UITextField(backgroundColor: #colorLiteral(red: 0.9493990541, green: 0.9533054233, blue: 0.9598917365, alpha: 1), cornerRadius: 10.0, textAlignment: .center)
    private let thirdCodeTextField = UITextField(backgroundColor: #colorLiteral(red: 0.9493990541, green: 0.9533054233, blue: 0.9598917365, alpha: 1), cornerRadius: 10.0, textAlignment: .center)
    private let firthCodeTextField = UITextField(backgroundColor: #colorLiteral(red: 0.9493990541, green: 0.9533054233, blue: 0.9598917365, alpha: 1), cornerRadius: 10.0, textAlignment: .center)
    private let fifthCodeTextField = UITextField(backgroundColor: #colorLiteral(red: 0.9493990541, green: 0.9533054233, blue: 0.9598917365, alpha: 1), cornerRadius: 10.0, textAlignment: .center)
    private let sixthCodeTextField = UITextField(backgroundColor: #colorLiteral(red: 0.9493990541, green: 0.9533054233, blue: 0.9598917365, alpha: 1), cornerRadius: 10.0, textAlignment: .center)
    
    
    
    lazy var txtFieldsStackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [firstCodeTextField,
                                                       secondCodeTextField,
                                                       thirdCodeTextField,
                                                       firthCodeTextField,
                                                       fifthCodeTextField,
                                                       sixthCodeTextField])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 7.0
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    
    //MARK: - Init -
    
    init(viewModel: VerificationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        navigationController?.navigationBar.isHidden = true
        setupLayout()
        addTargets()
        
        
        firstCodeTextField.delegate = self
        secondCodeTextField.delegate = self
        thirdCodeTextField.delegate = self
        firthCodeTextField.delegate = self
        fifthCodeTextField.delegate = self
        sixthCodeTextField.delegate = self
    }
    
    
    //MARK: - Methods -
    
    
    private func addTargets() {
        
        firstCodeTextField.addTarget(self, action: #selector(textDidEnter(_:)), for: .editingChanged)
        secondCodeTextField.addTarget(self, action: #selector(textDidEnter(_:)), for: .editingChanged)
        thirdCodeTextField.addTarget(self, action: #selector(textDidEnter(_:)), for: .editingChanged)
        firthCodeTextField.addTarget(self, action: #selector(textDidEnter(_:)), for: .editingChanged)
        fifthCodeTextField.addTarget(self, action: #selector(textDidEnter(_:)), for: .editingChanged)
        sixthCodeTextField.addTarget(self, action: #selector(textDidEnter(_:)), for: .editingChanged)
    }
    
    
    @objc
    private func textDidEnter(_ textField: UITextField) {
        
        
        if  textField.text?.count == 1 {
            
            switch textField {
            
            case firstCodeTextField:
                
                secondCodeTextField.becomeFirstResponder()
                
            case secondCodeTextField:
                
                thirdCodeTextField.becomeFirstResponder()
                
            case thirdCodeTextField:
                
                firthCodeTextField.becomeFirstResponder()
                
            case firthCodeTextField:
                
                fifthCodeTextField.becomeFirstResponder()
                
            case fifthCodeTextField:
                
                sixthCodeTextField.becomeFirstResponder()
                
            case sixthCodeTextField:
                
                view.endEditing(true)
            default:
                break
            }
        }
    }
    
    
    
    
    private func setupLayout() {
        
        view.addSubviews([titleLabel, explainLabel, txtFieldsStackView])
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15.0),
            titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8.0),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            explainLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            explainLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            explainLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            txtFieldsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            txtFieldsStackView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            txtFieldsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            txtFieldsStackView.heightAnchor.constraint(equalToConstant: (view.bounds.width * 0.8) / 6)
        ])
    }
}


//MARK: - Extension -

extension VerificationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.shadowRadius = 5.0
        textField.layer.shadowOffset = .zero
        textField.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        
        UIView.animate(withDuration: 0.2) {
            
            textField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            textField.layer.shadowOpacity = 0.4

        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.2) {
     
            textField.backgroundColor = #colorLiteral(red: 0.9493990541, green: 0.9533054233, blue: 0.9598917365, alpha: 1)
            textField.layer.shadowOpacity = 0.0
        }
    }
}
