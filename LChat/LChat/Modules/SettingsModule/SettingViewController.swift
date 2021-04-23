
import UIKit

final class SettingsViewController: UIViewController {
    
    
    //MARK: - Properties -
    
    var viewModel: SettingsViewModelProtocol
    var coordinator: SettingCoordinator?
    
    //MARK: Subviews
    
    private let themeTableViewCell = ThemeTableViewCell()
    private let chatCustomizeTableViewCell = ChatCustomizeTableViewCell()
    private let notificationTableViewCell = NotificationTableViewCell()
    private let deleteAccountTableViewCell = DeleteAccountTableViewCell()
    private let languageTableViewCell = LanguageTableViewCell()
    
    
    private lazy var settingTableView: UITableView = {
       
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .secondarySystemBackground
        table.separatorStyle = .none
        table.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        table.layer.shadowOpacity = 0.3
        table.layer.shadowRadius = 5.0
        table.layer.shadowOffset = .zero
        table.clipsToBounds = false
        table.rowHeight = 50.0
        view.addSubview(table)
        
        return table
    }()
    
    
    
    //MARK: - Init -
    
    
    init(viewModel: SettingsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Setting"

                
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        setTabBarItem()
        setupLayout()
        setupSettingsViewModelObserver()
        configThemeSwitcher()
        coordinator?.navigationController = navigationController!
    }
    
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.window?.overrideUserInterfaceStyle = UserDefaults.standard.interfaceStyle

    }

    
    //MARK: - Methods -
    
    private func setTabBarItem() {
        
        let image = UIImage(systemName: "gearshape.fill")
        let tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: nil)
        
        self.tabBarItem = tabBarItem
    }
    
    
    
    private func setupSettingsViewModelObserver() {
        
        viewModel.isDarkStyle.bind { [weak self] isDarkStyle in
            
            guard let isDarkStyle = isDarkStyle else { return }
            
            if isDarkStyle {
                
                self?.view.window?.overrideUserInterfaceStyle = .dark
                
            } else {
                
                self?.view.window?.overrideUserInterfaceStyle = .light
            }
        }
    }
   
    
    
    private func configThemeSwitcher() {
    
        if let isOn = viewModel.isDarkStyle.value {
            
            themeTableViewCell.themeSwitcher.isOn = isOn
        }
    
        
        themeTableViewCell.themeSwitcherAction = { isOn in
         
            self.viewModel.changeAppTheme(isOn)
        }
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


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        
        case 0:
            return themeTableViewCell
            
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        
        case 1:
            coordinator?.showCustomization()
            
        case 2:
            coordinator?.showNotification()
            
        case 3:
            coordinator?.showLanguages()
            
        default:
            break
        }
    }
}


