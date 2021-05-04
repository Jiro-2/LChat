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
