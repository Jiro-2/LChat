//
//  DeleteAccountTableViewCell.swift
//  LingoChat
//
//  Created by Егор on 18.03.2021.
//

import UIKit


final class DeleteAccountTableViewCell: UITableViewCell {
    
    
    //MARK: - Init -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.text = NSLocalizedString(
            "SettingViewController.DeleteAccountTableViewCell.textLabel",
            comment: "")
        
        self.textLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        self.textLabel?.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        
        setImageView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Methods -
    
    private func setImageView() {
        
        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30.0))
        self.imageView?.image = UIImage(systemName: "person.circle.fill")?.withConfiguration(configuration)
        self.imageView?.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    
}
