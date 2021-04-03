//
//  UsernameTextField.swift
//  LChat
//
//  Created by Егор on 30.03.2021.
//

import UIKit


final class UsernameTextField: UITextField {
    
    //MARK: - Property -
    
    var maxLength: Int?
    
    enum RightViewType {
        case xMark
        case checkMark
    }
    
    
    //MARK: - Init -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.rightViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methods -
    
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        let height = bounds.height * 0.5
        let topPadding = (bounds.height - height) / 2
        
       return  CGRect(x: self.frame.origin.x + bounds.width * 0.9, y: self.frame.origin.y + topPadding, width: height, height: height)
    }
    
    
    
    func changeRightView(type: RightViewType) {
             
        switch type {
        
        case .checkMark:
            
            rightView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill")?.withTintColor(#colorLiteral(red: 0.2525768876, green: 0.5986332893, blue: 0.5696017742, alpha: 1), renderingMode: .alwaysOriginal))
            
        case .xMark:
            
            rightView = UIImageView(image: UIImage(systemName: "multiply.circle.fill")?.withTintColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), renderingMode: .alwaysOriginal))
            
        }
    }
}

