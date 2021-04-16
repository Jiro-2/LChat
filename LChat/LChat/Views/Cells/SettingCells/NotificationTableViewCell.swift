//
//  SettingNotificationTableViewCell.swift
//  LingoChat
//
//  Created by Егор on 18.03.2021.
//

import UIKit

final class NotificationTableViewCell: UITableViewCell {
    
    
    //MARK: - Init -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.text = NSLocalizedString(
            "SettingViewController.NotificationTableViewCell.textLabel",
            comment: "")
        
        self.textLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        self.accessoryType = .disclosureIndicator
        
        setImageView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Methods -
    
    private func setImageView() {
        
        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30.0))
        self.imageView?.image = UIImage(systemName: "bell.circle.fill")?.withConfiguration(configuration)
        self.imageView?.tintColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    }
}
