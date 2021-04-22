//
//  DarkModeTableViewCell.swift
//  LingoChat
//
//  Created by Егор on 18.03.2021.
//

import UIKit

final class DarkModeTableViewCell: UITableViewCell {
    
    
    //MARK: - Properties -
    
    private lazy var darkModeSwitcher = UISwitch(frame: .zero, primaryAction: UIAction(handler: { _ in
        
        print("Switch")
        
    }))
    
    
    
    
    //MARK: - Init -
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.text = NSLocalizedString(
            "SettingViewController.DarkModeTableViewCell.textLabel".localized,
            comment: "")
        self.textLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        self.accessoryView = darkModeSwitcher
        
        setImageView()
        setLocalizedText()

    }
    
    
    private func setLocalizedText() {
        
        LanguageManager.shared.didChangeLangBlocks.append {
            
            self.textLabel?.text = NSLocalizedString(
                "SettingViewController.DarkModeTableViewCell.textLabel".localized,
                comment: "")
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Methods -
    
    private func setImageView() {
        
        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30.0))
        self.imageView?.image = UIImage(systemName: "moon.circle.fill")?.withConfiguration(configuration)
        self.imageView?.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
}


