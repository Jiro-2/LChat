import UIKit

final class MyImageView: UIImageView {
    
    var didSetImageBlock: ((_ image: UIImage?) -> ())?
    
    override var image: UIImage? {
        
        didSet {
            self.didSetImageBlock?(image)
        }
    }
}
