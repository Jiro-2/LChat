//
//  Character+Extension.swift
//  LingoChat
//
//  Created by Егор on 28.01.2021.
//

import Foundation


extension Character {
    
    func convertToUpperCase() -> Character {
        if(self.isUppercase){
            return self
        }
        return Character(self.uppercased())
    }
}
