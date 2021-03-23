//
//  Navigator.swift
//  LingoChat
//
//  Created by Егор on 15.01.2021.
//

import Foundation

protocol Navigator {
    associatedtype Destination
    
    func navigate(to destination: Destination, presented: Bool)
}
