import UIKit

protocol SearchUserViewControllerDelegate: class {
    
    func viewController(_ viewController: UIViewController, foundUser user: User)
}


final class SearchUserViewController: UIViewController {
    
    
    //MARK: - Properties -
    
    var viewModel: SearchUserViewModelProtocol
    weak var delegate: SearchUserViewControllerDelegate?
    var coordinator: MainCoordinator?
    
    var isSearching = false {
        
        didSet {
            
            if isSearching {
                
                searchImageView.isHidden = true
                descriptionLabel.isHidden = true
                tableView.isHidden = false
                
            } else {
                
                searchImageView.isHidden = false
                descriptionLabel.isHidden = false
                tableView.isHidden = true
            }
        }
    }
    
    
    var users: [User] = [] {
        
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    private lazy var searchController: UISearchController = {
        
        var searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchTextField.layer.cornerRadius = 10.0
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.setImage(UIImage(systemName: "xmark")?.withTintColor(.white), for: .clear, state: .normal)
        searchController.searchBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let txtField = searchController.searchBar.value(forKey: "searchField") as? UITextField
        let text = NSLocalizedString("SearchViewController.SearchController.placeholder", comment: "")
        
        txtField?.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        txtField?.leftView?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        txtField?.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        txtField?.autocapitalizationType = .none
        
        return searchController
    }()
    
    
    
     lazy var tableView: UITableView = {
        
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UserTableViewCell.self, forCellReuseIdentifier: "userCellID")
        table.separatorStyle = .none
        view.addSubview(table)
        
        return table
    }()
    
    
    
    private lazy var searchImageView: UIImageView = {
        
        let image = UIImageView(image: UIImage(named: "search"))
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        
        return image
    }()
    
    
    
    private lazy var descriptionLabel: UILabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("SearchViewController.descriptionLabel",
                                       comment: "")
        label.textAlignment = .center
        label.backgroundColor = view.backgroundColor
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.numberOfLines = 0
        view.addSubview(label)
        
        return label
    }()
    
    
    
    //MARK: - Init -
    
    init(viewModel: SearchUserViewModelProtocol) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        ThemeManager.shared.removeObserver(self)
    }
    
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeManager.shared.addObserver(self)
        view.backgroundColor = ThemeManager.shared.primaryColor
        
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        setupLayout()
        setupViewModelObserving()
    }
    
    

    
    //MARK: - Methods -
    
    private func setupViewModelObserving() {
        
        viewModel.searchResult.bind { [weak self] users in
            
            guard let users = users else { return }
            self?.users = users
        }
    }
    
    
    func subscribeDelegate() {
        
       let vc = self.coordinator?.navigationController.topViewController as? ChatViewController
        self.delegate = vc
    }
    
    
    
    private func setupLayout() {
        
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            searchImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            searchImageView.widthAnchor.constraint(equalTo: view.widthAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: searchImageView.bottomAnchor),
            descriptionLabel.centerXAnchor.constraint(equalTo: searchImageView.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
    }
}


//MARK: - Extension -

extension SearchUserViewController: ThemeObserver {
    
    func didChangePrimaryColor(_ color: UIColor) {
     
        view.backgroundColor = color
    }
}
