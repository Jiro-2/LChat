import UIKit

final class SliderView: UIView {
    
    var sliderActionBlock: ((Float) -> ())?
    let primaryColor = ThemeManager.shared.primaryColor
    
    
    //MARK:  - Subviews -
    
    lazy var slider: UISlider = {
        
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.thumbTintColor = primaryColor
        slider.minimumTrackTintColor = primaryColor
        addSubview(slider)
        slider.addAction(UIAction(handler: { _ in
            
            self.sliderActionBlock?(slider.value)
            self.sliderValueLabel.text = "\(Int(slider.value))"
            
        }), for: .valueChanged)
        
        return slider
    }()
    
    
    
    lazy var sliderValueLabel: UILabel = {
        
        let label = UILabel(text: "\(Int(slider.value))",
                            font: UIFont.boldSystemFont(ofSize: 18.0),
                            textColor: primaryColor)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        addSubview(label)
        
        return label
    }()
    
    
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13.0)
        label.textColor = primaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        return label
    }()
    
    
    
    //MARK: - Init -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ThemeManager.shared.addObserver(self)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        ThemeManager.shared.removeObserver(self)
    }
    
    //MARK: - Methods -
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0),
            
            sliderValueLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            sliderValueLabel.centerYAnchor.constraint(equalTo: slider.centerYAnchor),
            sliderValueLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            
            slider.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0),
            slider.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            slider.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            
        ])
    }
}


//MARK: - Extension -


extension SliderView {
    
    convenience init(title: String, sliderMinValue: Float, sliderMaxValue: Float) {
        self.init()
        self.titleLabel.text = title
        self.slider.minimumValue = sliderMinValue
        self.slider.maximumValue = sliderMaxValue
    }
}


extension SliderView: ThemeObserver {
    
    func didChangePrimaryColor(_ color: UIColor) {
        
        sliderValueLabel.textColor = color
        slider.thumbTintColor = color
        slider.minimumTrackTintColor = color
        titleLabel.textColor = color
    }
}
