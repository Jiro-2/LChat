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
    
    
    convenience init(text: String, font: UIFont, textColor: UIColor) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}

