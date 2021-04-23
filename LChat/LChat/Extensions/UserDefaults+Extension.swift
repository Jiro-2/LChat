//
//  UserDefaults+Extension.swift
//  LChat
//
//  Created by Егор on 22.04.2021.
//

import UIKit

extension UserDefaults {
    
    var interfaceStyle: UIUserInterfaceStyle {
        
        get {

            UIUserInterfaceStyle.init(rawValue: integer(forKey: "interface_style")) ?? .unspecified
        }
        
        set {

            set(newValue.rawValue, forKey: "interface_style")
        }
    }
}
