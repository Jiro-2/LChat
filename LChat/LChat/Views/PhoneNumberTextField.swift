import UIKit

class PhoneNumberTextField: UITextField {
    
    //MARK: - Properties
    
    var leftViewTapAction: (() -> ())?
    
    // Subviews
    
    private let chevronUp = UIImageView(image: UIImage(systemName: "chevron.up"))
    private let chevronDown = UIImageView(image: UIImage(systemName: "chevron.down"))
    
    
    var leftViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.text = "+000"
        
        return label
    }()
    
    
    //MARK: - Init -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        placeholder = "00 000 00 00"
        keyboardType = .numberPad
        
        leftViewMode = .always
        leftView = leftViewLabel
        
        chevronUp.isHidden = true
        
        configImages()
        layoutImages()
        addGestureToLeftView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methods -

    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        super.leftViewRect(forBounds: bounds)
        
        return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width * 0.25, height: bounds.size.height)
    }
    
    
    
    
    private func addGestureToLeftView() {
        
        if leftView != nil {
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(leftViewTapped))
            leftViewLabel.isUserInteractionEnabled = true
            leftViewLabel.addGestureRecognizer(tap)
        }
    }
    
    
    
    @objc
    private func leftViewTapped() {
        
        if chevronUp.isHidden {
            
            chevronUp.isHidden = false
            chevronDown.isHidden = true
            
        } else {
            
            chevronUp.isHidden = true
            chevronDown.isHidden = false
        }
        
        self.leftViewTapAction?()
    }
    
    
    private func configImages() {
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 13.0, weight: .black)
        
        chevronUp.preferredSymbolConfiguration = configuration
        chevronDown.preferredSymbolConfiguration = configuration
        
        chevronUp.tintColor = #colorLiteral(red: 0.7401513457, green: 0.7386283278, blue: 0.7552842498, alpha: 1)
        chevronDown.tintColor = #colorLiteral(red: 0.7401513457, green: 0.7386283278, blue: 0.7552842498, alpha: 1)
    }
    
    
    private func layoutImages() {
        
        chevronUp.translatesAutoresizingMaskIntoConstraints = false
        chevronDown.translatesAutoresizingMaskIntoConstraints = false
        
        leftView?.addSubviews([chevronUp, chevronDown])
        
        
        if let leftView = self.leftView {
            
            NSLayoutConstraint.activate([
                
                chevronUp.centerYAnchor.constraint(equalTo: leftView.centerYAnchor),
                chevronUp.rightAnchor.constraint(equalTo: leftView.rightAnchor,constant: -2.0),
                
                chevronDown.centerYAnchor.constraint(equalTo: leftView.centerYAnchor),
                chevronDown.rightAnchor.constraint(equalTo: leftView.rightAnchor, constant: -2.0)
            ])
        }
    }
}
