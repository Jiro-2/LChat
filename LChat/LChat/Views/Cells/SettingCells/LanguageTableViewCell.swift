//
//  LanguageTableViewCell.swift
//  LingoChat
//
//  Created by Егор on 18.03.2021.
//

import UIKit

final class LanguageTableViewCell: UITableViewCell {
    
    
    //MARK: - Init -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .secondarySystemBackground
        self.textLabel?.text = NSLocalizedString(
            "SettingViewController.LanguageTableViewCell.textLabel".localized,
            comment: "")

        self.textLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        self.accessoryType = .disclosureIndicator
        
        setImageView()
        setLocalizedText()

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Methods -
    
    
    private func setLocalizedText() {
        
        
        LanguageManager.shared.didChangeLangBlocks.append {
            
            self.textLabel?.text = NSLocalizedString("SettingViewController.LanguageTableViewCell.textLabel".localized, comment: "")
        }
    }
    
    
    
    
    private func setImageView() {
        
        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30.0))
        self.imageView?.image = UIImage(systemName: "globe")?.withConfiguration(configuration)
        self.imageView?.tintColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
    }
}
