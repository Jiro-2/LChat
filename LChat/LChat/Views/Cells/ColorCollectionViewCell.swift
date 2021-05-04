import UIKit


final class ColorCollectionViewCell: UICollectionViewCell {
    
    
    //MARK: - Properties -
    
    
    override var isSelected: Bool {
        
        didSet {
            
            if !isSelected {
                
                UIView.animate(withDuration: 0.3) {
                    
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.removeBorder()
                }
            }
        }
    }
    
    
    
    //MARK: - Methods -
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
        
        if isSelected {
        
            removeBorder()
            
            UIView.animate(withDuration: 0.3) {
                
                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }
            
            addBorder()
        }
    }
    
    
    private func addBorder() {
        
        let indent = bounds.height * 0.1
        let borderWidth = bounds.height * 0.15
        
        addBorder(withIndent: indent, width: borderWidth, color: self.backgroundColor ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }
    
    
    
    private func removeBorder() {
        
        if let borderLayerIndex = layer.sublayers?.firstIndex(where:)({ $0.name == "IndentBorderLayer" }) {
            
            layer.sublayers?[borderLayerIndex].removeFromSuperlayer()
        }
    }
}
