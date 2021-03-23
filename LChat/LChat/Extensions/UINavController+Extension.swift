//
//  UINavController+Extension.swift
//  LingoChat
//
//  Created by Егор on 08.02.2021.
//

import UIKit

extension UINavigationController {
    
    func previousViewController() -> UIViewController? {
        
        if self.viewControllers.count == 1 || self.viewControllers.count == 0 {
            
            return nil
        }
        
        if self.viewControllers.count == 2 {
            return viewControllers[0]
            
        } else {
            
            return viewControllers[viewControllers.count - 2]
        }
    }
}
