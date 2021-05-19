import UIKit

class ChatTableViewCell: UITableViewCell {
    

    //MARK: - Subviews
    
    
    let userNameLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19.0, weight: .semibold)
        
        return label
    }()
    
    
    let lastMessageLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15.0)
        label.textColor = .gray
        
        return label
    }()
    
    
    let avatarImageView: UIImageView = {
        
        let image = UIImageView(image: UIImage(systemName: "person.fill"))
        image.tintColor = .gray
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = ThemeManager.shared.primaryColor
        
        return image
    }()
    
    
    let unSeenMessagesLabel: UnSeenMessageBadgeLabel = {
       
        let label = UnSeenMessageBadgeLabel(withInsets: 5.0, 5.0, 5.0, 5.0)
        label.font = .systemFont(ofSize: 13)
        label.text = "0"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.clipsToBounds = true
        label.backgroundColor = ThemeManager.shared.primaryColor
        label.sizeToFit()
        
        return label
    }()
    
    
    
    //MARK: - Init -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubviews([avatarImageView, userNameLabel, lastMessageLabel])
        self.selectionStyle = .none
        self.accessoryView = unSeenMessagesLabel
        self.accessoryView?.isHidden = true
        
        
        ThemeManager.shared.addObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        ThemeManager.shared.removeObserver(self)
    }
    

    //MARK: - Methods -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
        avatarImageView.roundCorners(avatarImageView.bounds.size.height / 2.0)
        unSeenMessagesLabel.roundCorners(unSeenMessagesLabel.bounds.size.height / 2.0)
    }
    
    
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15.0),
            avatarImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor),
            
            userNameLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            userNameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 8.0),
            
            lastMessageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5.0),
            lastMessageLabel.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor),
            lastMessageLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6)
        ])
    }
}


//MARK: - Extension -

extension ChatTableViewCell: ThemeObserver {
    
    func didChangePrimaryColor(_ color: UIColor) {
     
        unSeenMessagesLabel.backgroundColor = color
    }
}
