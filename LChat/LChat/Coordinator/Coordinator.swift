//
//  Coordinator.swift
//  LChat
//
//  Created by Егор on 27.03.2021.
//


import UIKit

protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
