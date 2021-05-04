import UIKit

extension UITextField {
    
    convenience init(placeholder: String) {
        self.init()
        self.placeholder = placeholder
    }
    
    
    convenience init(backgroundColor color: UIColor, cornerRadius radius: CGFloat, textAlignment: NSTextAlignment) {
        self.init()
        self.backgroundColor = color
        self.layer.cornerRadius = radius
        self.textAlignment = textAlignment
    }
}




extension UITextField {
    func useUnderline(withColor color: UIColor, thickness: CGFloat) {
    
    let underLine = UIView()
        underLine.translatesAutoresizingMaskIntoConstraints = false
        underLine.backgroundColor = color
        
        self.addSubview(underLine)
        
        //Layout
        underLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        underLine.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        underLine.heightAnchor.constraint(equalToConstant: thickness).isActive = true
        underLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.bounds.size.height * 0.15).isActive = true
  }
}

extension UITextField {
    
    func addLeftPadding(with points: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: points, height: self.bounds.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}


