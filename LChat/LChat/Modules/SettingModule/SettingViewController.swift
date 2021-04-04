//
//  SettingViewController.swift
//  LingoChat
//
//  Created by Егор on 18.03.2021.
//

import UIKit

final class SettingViewController: UIViewController {
    
    //MARK: - Properties -
    
    var viewModel: SettingViewModelProtocol
    
    //MARK: Subviews
    
    private let darkModeTableViewCell = DarkModeTableViewCell()
    private let chatCustomizeTableViewCell = ChatCustomizeTableViewCell()
    private let notificationTableViewCell = NotificationTableViewCell()
    private let deleteAccountTableViewCell = DeleteAccountTableViewCell()
    private let languageTableViewCell = LanguageTableViewCell()
    
    
    private lazy var settingTableView: UITableView = {
       
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        table.layer.shadowOpacity = 0.3
        table.layer.shadowRadius = 5.0
        table.layer.shadowOffset = .zero
        table.clipsToBounds = false
        table.rowHeight = 50.0
        table.allowsSelection = false
        return table
    }()
    
    
    
    //MARK: - Init -
    
    
    init(viewModel: SettingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9679402709, green: 0.964915216, blue: 0.9647199512, alpha: 1)
        title = "Setting"

        view.addSubview(settingTableView)
                
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        setTabBarItem()
        setupLayout()
    }
    
    //MARK: - Methods -
    
    
    private func setTabBarItem() {
        
        let image = UIImage(systemName: "gearshape.fill")
        let tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: nil)
        
        self.tabBarItem = tabBarItem
    }
    
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
        
            settingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15.0),
            settingTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15.0),
            settingTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15.0),
            settingTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        
        ])
    }
}


//MARK: - Extension -


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        
        case 0:
            return darkModeTableViewCell
            
        case 1:
            return chatCustomizeTableViewCell
            
        case 2:
            return  notificationTableViewCell
            
        case 3:
            return languageTableViewCell

        case 4:
            return deleteAccountTableViewCell
            
        default:
            return UITableViewCell()
        }
    }
}


