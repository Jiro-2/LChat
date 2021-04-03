//
//  AuthFormView.swift
//  LChat
//
//  Created by Егор on 24.03.2021.
//

import UIKit

class AuthView: UIView {
    
    //MARK: - Properties -
    
    var buttonAction: (() -> ())?
    
    //Subviews
    
    public lazy var titleLabel: UILabel = {
        
        let label = UILabel(font: UIFont.systemFont(ofSize: 35.0, weight: .bold), textAlignment: .left)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        
        return label
    }()
    
    
    lazy var usernameTxtField: UsernameTextField = {
        
        let txtField = UsernameTextField(placeholder: " User Name")
        txtField.backgroundColor = #colorLiteral(red: 0.9526441693, green: 0.9536944032, blue: 0.9636160731, alpha: 1)
        txtField.layer.cornerRadius = 10.0
        
        return txtField
    }()
    
    
    
    lazy var phoneTxtField: PhoneNumberTextField = {
        
        let txtField = PhoneNumberTextField()
        txtField.backgroundColor = #colorLiteral(red: 0.9533203244, green: 0.9572271705, blue: 0.9638128877, alpha: 1)
        txtField.layer.cornerRadius = 10.0
        
        return txtField
    }()
    
    
    
    lazy var button: UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .primaryColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        button.addAction(UIAction(handler: { _ in
            
            self.buttonAction?()
            
        }), for: .touchUpInside)
        
        return button
    }()
    
    
    
    
    lazy var stackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [usernameTxtField, phoneTxtField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
        
        return stackView
    }()
    
    
    
    //MARK: - Init -
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methods -
    
    
    private func setupLayout() {
        
        addSubviews([titleLabel, stackView, button])
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0),
            
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            stackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.28),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.0),
            
            
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20.0),
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15),
            button.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        ])
    }
}
