//
//  Extension+UITextField.swift
//  LingoChat
//
//  Created by Егор on 05.01.2021.
//

import UIKit

extension UITextField {
    
    
    convenience init(placeholder: String) {
        self.init()
        self.placeholder = placeholder
    }
    
    
    
    convenience init(borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat, leftPadding: CGFloat) {
        self.init()
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
        self.addLeftPadding(with: leftPadding)
    }
    
    
    convenience init(borderColor: UIColor, borderWidth: CGFloat, textAlignment: NSTextAlignment = .center, tintColor: UIColor, font: UIFont?, cornerRadius: CGFloat) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.textAlignment = textAlignment
        self.tintColor = tintColor
        self.font = font
        self.layer.cornerRadius = cornerRadius
    }
}




extension UITextField {
    func useUnderline(withColor color: UIColor, thickness: CGFloat) {
    
    let underLine = UIView()
        underLine.translatesAutoresizingMaskIntoConstraints = false
        underLine.backgroundColor = color
        
        self.addSubview(underLine)
        
        //Layout
        underLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        underLine.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        underLine.heightAnchor.constraint(equalToConstant: thickness).isActive = true
        underLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.bounds.size.height * 0.15).isActive = true
  }
}

extension UITextField {
    func addLeftPadding(with points: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: points, height: self.bounds.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

