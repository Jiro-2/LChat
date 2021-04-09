//
//  UserTableViewCell.swift
//  LingoChat
//
//  Created by Егор on 14.02.2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    //MARK: - Subview
    
    lazy var userNameLabel: UILabel = {
       
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 18.0, weight: .medium)
        
        return lbl
    }()
    

    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(userNameLabel)
        self.contentMode = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
        
            userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
            userNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0)
        ])
    }
}
