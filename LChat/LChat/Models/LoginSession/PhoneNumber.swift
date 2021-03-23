//
//  PhoneNumber.swift
//  LingoChat
//
//  Created by Егор on 10.02.2021.
//

import Foundation


struct PhoneNumber {
    
    var callingCode: String
    var number: String
    
    var fullPhoneNumber: String {
        
        get {
            return callingCode + number
        }
    }
}
