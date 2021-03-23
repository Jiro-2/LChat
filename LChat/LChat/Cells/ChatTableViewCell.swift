//
//  ChatTableViewCell.swift
//  LingoChat
//
//  Created by Егор on 01.03.2021.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    
    //MARK: - Properties -
    
    
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
    
    
    let avatarView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        
        return view
    }()
    
    
    let unSeenMessagesLabel: UnSeenMessageBadgeLabel = {
       
        let label = UnSeenMessageBadgeLabel(withInsets: 5.0, 5.0, 5.0, 5.0)
        label.font = .systemFont(ofSize: 12)
        label.text = "0"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.clipsToBounds = true
        label.backgroundColor = .primaryColor
        label.sizeToFit()
        
        return label
    }()
    
    
    
    //MARK: - Init -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubviews([avatarView, userNameLabel, lastMessageLabel])
        self.selectionStyle = .none
        self.accessoryView = unSeenMessagesLabel
        self.accessoryView?.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methods -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
        avatarView.roundCorners(avatarView.bounds.size.height / 2.0)
        unSeenMessagesLabel.roundCorners(unSeenMessagesLabel.bounds.size.height / 2.0)
    }
    
    
    //MARK: - Private
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            
            avatarView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15.0),
            avatarView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor),
            
            userNameLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            userNameLabel.leftAnchor.constraint(equalTo: avatarView.rightAnchor, constant: 8.0),
            
            lastMessageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5.0),
            lastMessageLabel.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor)
        ])
    }
}
