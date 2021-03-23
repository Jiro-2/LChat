//
//  UserRegister.swift
//  LingoChat
//
//  Created by Егор on 10.02.2021.
//

import Foundation

struct UserRegisterData {
    
    static var shared = UserRegisterData()
    
    public var phone = PhoneNumber(callingCode: "", number: "")
}
