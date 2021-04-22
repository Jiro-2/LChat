//
//  MyImageView.swift
//  LChat
//
//  Created by Егор on 15.04.2021.
//

import UIKit

final class MyImageView: UIImageView {
    
    var didSetImageBlock: ((_ image: UIImage?) -> ())?
    
    override var image: UIImage? {
        
        didSet {
            self.didSetImageBlock?(image)
        }
    }
}
