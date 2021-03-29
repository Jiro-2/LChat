//
//  String+Extension.swift
//  LingoChat
//
//  Created by Егор on 02.02.2021.
//

import Foundation

extension String {
    
    var isNumeric: Bool {
        
        guard self.count > 0 else { return false }
        
        let digits: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let set: Set<Character> = Set(self)
        
        return Set(set).isSubset(of: digits)
    }
    
    var isValidPhone: Bool {
                
        let phonePattern = "[0-9]{3}[ -]?[0-9]{3}[ -]?[0-9]{4}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", phonePattern)
        
         return predicate.evaluate(with: self)
    }
}

