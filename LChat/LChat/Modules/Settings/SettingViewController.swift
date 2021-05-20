import UIKit

final class SettingsViewController: UIViewController {
    
    
    //MARK: - Properties -
    
    var viewModel: SettingsViewModelProtocol
    var coordinator: SettingCoordinator?
    
    //MARK: Subviews
    
    private let themeTableViewCell = ThemeTableViewCell()
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
    
    
    private let colorsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        collection.backgroundColor = .secondarySystemBackground

        return collection
    }()
    
    
    //MARK: - Init -
    
    
    init(viewModel: SettingsViewModelProtocol) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tabBarItem.image = UIImage(systemName: "gearshape.fill")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(colorsCollectionView)
        
                
        settingTableView.delegate = self
        settingTableView.dataSource = self
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        
        setupSettingsViewModelObserver()
        configThemeSwitcher()
        coordinator?.navigationController = navigationController!
        
        let item = self.viewModel.indexPrimaryColor
        let cell = self.colorsCollectionView.cellForItem(at: IndexPath(item: item, section: 0))
        cell?.isSelected = true
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.window?.overrideUserInterfaceStyle = UserDefaults.standard.interfaceStyle
        scrollToPrimaryColor()
    }

    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        guard let layout = colorsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.invalidateLayout()
    }
    
    
    //MARK: - Methods -
    
  
    private func scrollToPrimaryColor() {
                        
        guard let index = viewModel.colors.firstIndex(of: viewModel.primaryColor.value!) else { return }
        
        DispatchQueue.main.async {
        
            UIView.animate(withDuration: 0.3) {
                
                self.colorsCollectionView.scrollToItem(at:
                                                        IndexPath(item: index, section: 0),
                                                       at: .right,
                                                       animated: true)
            }
        }
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
            settingTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            colorsCollectionView.topAnchor.constraint(equalTo: settingTableView.bottomAnchor),
            colorsCollectionView.centerXAnchor.constraint(equalTo: settingTableView.centerXAnchor),
            colorsCollectionView.widthAnchor.constraint(equalTo: settingTableView.widthAnchor),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: settingTableView.rowHeight)
        
        ])
    }
}


//MARK: - Extension -



//MARK: TableView


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        
        case 0:
            return themeTableViewCell
            
            
        case 1:
            return languageTableViewCell

        case 2:
            return deleteAccountTableViewCell
            
        default:
            return UITableViewCell()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        
        case 1:
            coordinator?.showLanguages()
            
        default:
            break
        }
    }
}



//MARK: CollectionView


extension SettingsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.backgroundColor = viewModel.colors[indexPath.row]

        if viewModel.indexPrimaryColor == indexPath.row  {

            cell.isSelected = true
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: IndexPath(item: viewModel.indexPrimaryColor, section: 0)) {

            cell.isSelected = false
        }

        viewModel.primaryColor.value = viewModel.colors[indexPath.item]
        viewModel.setPrimaryColor(viewModel.colors[indexPath.item])
    }
}


extension SettingsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        viewModel.colors.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
    }
}


extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        view.bounds.height * 0.1 / 2
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
         CGSize(width: collectionView.bounds.height * 0.8, height: collectionView.bounds.height * 0.8)
    }
}
