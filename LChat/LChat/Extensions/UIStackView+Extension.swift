import UIKit

extension UIStackView {
    
    func addArrangedViews(_ views: [UIView]) {
        views.forEach { view  in
            self.addArrangedSubview(view)
        }
    }
}
