//
//  UIImage+Extension.swift
//  LingoChat
//
//  Created by Егор on 20.03.2021.
//

import UIKit

extension UIImageView {
    
    func setImage(from url: URL) {
        
        DispatchQueue.global().async {
            
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
