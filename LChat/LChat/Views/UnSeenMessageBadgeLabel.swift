import UIKit

class UnSeenMessageBadgeLabel: UILabel {

    var topInset: CGFloat
    var bottomInset: CGFloat
    var rightInset: CGFloat
    var leftInset: CGFloat

    
    required init(withInsets top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
           self.topInset = top
           self.bottomInset = bottom
           self.leftInset = left
           self.rightInset = right
           super.init(frame: CGRect.zero)
       }
       
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        
        var rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        rect.size.width += (rightInset + leftInset) * 2
        rect.size.height += topInset + leftInset
        
        return rect
    }
}
