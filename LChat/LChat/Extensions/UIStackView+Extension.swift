//
//  UIStackView+Extension.swift
//  LingoChat
//
//  Created by Егор on 13.01.2021.
//

import UIKit

extension UIStackView {
    
    func addArrangedViews(_ views: [UIView]) {
        views.forEach { view  in
            self.addArrangedSubview(view)
        }
    }
}
