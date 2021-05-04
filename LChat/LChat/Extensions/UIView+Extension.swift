import UIKit

extension UIView {
    
    func roundCorners(_ value: CGFloat) {
        self.layer.cornerRadius = value
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    
    func addSubviews(_ views: [UIView]) {
        
        views.forEach { subview in
            self.addSubview(subview)
        }
    }
}



extension UIView {
    
    enum BorderSide {
        case top
        case right
        case left
        case bottom
    }
    
    
    func addBorder(side: BorderSide, thickness: CGFloat, color: UIColor) {
        
        switch side {
        case .top:
            let border = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: thickness))
            border.backgroundColor = color
            self.addSubview(border)
            
        case .bottom:
            let border = UIView(frame: CGRect(x: 0, y: self.bounds.size.height - thickness, width: self.bounds.size.width, height: thickness))
            border.backgroundColor = color
            self.addSubview(border)
            
        case .right:
            let border = UIView(frame: CGRect(x: self.bounds.size.width - thickness, y: 0, width: thickness, height: self.bounds.size.height))
            border.backgroundColor = color
            self.addSubview(border)
            
        case .left:
            let border = UIView(frame: CGRect(x: 0, y: 0, width: thickness, height: self.bounds.size.height))
            self.backgroundColor = color
            self.addSubview(border)
        }
    }
    
    
    
    func addBorder(withIndent indent: CGFloat, width: CGFloat, color: UIColor) {
        
        let borderLayer = CAShapeLayer()
        borderLayer.name = "IndentBorderLayer"
        borderLayer.lineWidth = width
        borderLayer.strokeColor = color.cgColor
        borderLayer.fillColor = nil
        borderLayer.lineCap = .square
        
        borderLayer.path = UIBezierPath(roundedRect: CGRect(x: -width / 2 - indent,
                                                            y: -width / 2 - indent,
                                                            width: bounds.width + width + 2 * indent,
                                                            height: bounds.height + width + 2 * indent),
                                                            cornerRadius: layer.cornerRadius).cgPath
       
        layer.addSublayer(borderLayer)
    }
}
