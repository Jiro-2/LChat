//
//  PhoneNumberTextField.swift
//  LingoChat
//
//  Created by Егор on 22.01.2021.
//

import UIKit

protocol PhoneNumberTextFieldDelegate: class {
    func leftViewTapped()
}

class PhoneNumberTextField: UITextField {
    
    //MARK: - Properties
    
    weak var leftViewDelegate: PhoneNumberTextFieldDelegate?
    
    
    //MARK: - Subviews
    
    private let chevronUp = UIImageView(image: UIImage(systemName: "chevron.up"))
    private let chevronDown = UIImageView(image: UIImage(systemName: "chevron.down"))
    
    
    var countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "KohinoorTelugu-Medium", size: 20.0)
        label.textAlignment = .center
        label.text = "+000"
        
        return label
    }()
    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        placeholder = "00 000 00 00"
        keyboardType = .numberPad
        
        addLeftView(countryLabel)
        
        leftView?.addSubview(chevronUp)
        leftView?.addSubview(chevronDown)
        
        chevronUp.isHidden = true
        
        configImages()
        layoutImages()
        addGestureToLeftView()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        super.leftViewRect(forBounds: bounds)
        
        return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width * 0.25, height: bounds.size.height)
    }
    
    
    @objc
    func leftViewTapped() {
        
        if chevronUp.isHidden {
            
            chevronUp.isHidden = false
            chevronDown.isHidden = true
            
        } else {
            
            chevronUp.isHidden = true
            chevronDown.isHidden = false
        }
    }
    
    
    //MARK: - Private
    
    
    private func addGestureToLeftView() {
        
        if leftView != nil {
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(leftViewTapped))
            tap.delegate = self
            countryLabel.isUserInteractionEnabled = true
            countryLabel.addGestureRecognizer(tap)
        }
    }
    
    
    
    private func addLeftView(_ leftView: UIView) {
        
        self.leftViewMode = .always
        self.leftView = leftView
    }
    
    
    
    private func configImages() {
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 13.0, weight: .black)
        
        chevronUp.preferredSymbolConfiguration = configuration
        chevronDown.preferredSymbolConfiguration = configuration
        
        chevronUp.tintColor = #colorLiteral(red: 0.7401513457, green: 0.7386283278, blue: 0.7552842498, alpha: 1)
        chevronDown.tintColor = #colorLiteral(red: 0.7401513457, green: 0.7386283278, blue: 0.7552842498, alpha: 1)
    }
    
    
    
    private func layoutImages() {
        chevronUp.translatesAutoresizingMaskIntoConstraints = false
        chevronDown.translatesAutoresizingMaskIntoConstraints = false
        
        if let leftView = self.leftView {
            
            NSLayoutConstraint.activate([
                
                chevronUp.centerYAnchor.constraint(equalTo: leftView.centerYAnchor),
                chevronUp.rightAnchor.constraint(equalTo: leftView.rightAnchor,constant: -2.0),
                
                chevronDown.centerYAnchor.constraint(equalTo: leftView.centerYAnchor),
                chevronDown.rightAnchor.constraint(equalTo: leftView.rightAnchor, constant: -2.0)
            ])
        }
    }
}



extension PhoneNumberTextField: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        
        leftViewDelegate?.leftViewTapped()
        
        return true
    }
}
