//
//  Extension+UILabel.swift
//  LingoChat
//
//  Created by Егор on 05.01.2021.
//

import UIKit

extension UILabel {
    
    
    
    convenience init(font: UIFont, textAlignment: NSTextAlignment) {
        self.init()
        self.font = font
        self.textAlignment = textAlignment
    }
    
    
    
    convenience init(text: String, fontSize: CGFloat, textColor: UIColor) {
        self.init()
        
        guard let font = UIFont(name: "KohinoorTelugu-Medium", size: fontSize) else { return }
        self.text = text
        self.font = font
        self.textColor = textColor
        self.backgroundColor = .white
        self.numberOfLines = 0
        self.textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
}

