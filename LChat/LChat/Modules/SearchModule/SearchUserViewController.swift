//
//  SearchViewController.swift
//  LingoChat
//
//  Created by Егор on 12.02.2021.
//

import UIKit


protocol SearchUserViewControllerDelegate: class {
    
    func viewController(_ viewController: UIViewController, foundUser user: User)
}


final class SearchUserViewController: UIViewController {
    
    
    //MARK: - Properties -
    
    var viewModel: SearchUserViewModelProtocol
    var coordinator: MainCoordinator?
    weak var delegate: SearchUserViewControllerDelegate?
    
    var users: [User] = [] {
        
        didSet {
            tableView.reloadData()
        }
    }
    
    
    private var sharedConstraints = [NSLayoutConstraint]()
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    private var regxRegConstraints = [NSLayoutConstraint]()
    

    
    
    private lazy var searchController: UISearchController = {
        var searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchTextField.layer.cornerRadius = 10.0
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.setImage(UIImage(systemName: "xmark")?.withTintColor(.white), for: .clear, state: .normal)
        searchController.searchBar.tintColor = .white
        
        let txtField = searchController.searchBar.value(forKey: "searchField") as? UITextField
        txtField?.attributedPlaceholder = NSAttributedString(string: "Search friends", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        txtField?.leftView?.tintColor = .white
        txtField?.backgroundColor = UIColor.primaryColor
        txtField?.autocapitalizationType = .none
        
        return searchController
    }()
    
    
     lazy var tableView: UITableView = {
        
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UserTableViewCell.self, forCellReuseIdentifier: "userCellID")
        table.separatorStyle = .none
        
        return table
    }()
    
    
    
    private lazy var searchImageView: UIImageView = {
        
        let image = UIImageView(image: UIImage(named: "search"))
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    
    
    private lazy var descriptionLabel: UILabel = {
       
        let lbl = UILabel()
        lbl.backgroundColor = view.backgroundColor
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    
    
    //MARK: - Init -
    
    init(viewModel: SearchUserViewModelProtocol) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.primaryColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        setupSearchController()
        configureNavigationBar()
        setupLayout()
        
      //  setupConstraints()
      //  layoutTrait(traitCollection: UIScreen.main.traitCollection)
        
        setupViewModelSearchingObserver()
    }
    
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        layoutTrait(traitCollection: traitCollection)
//    }
//
    
    
    //MARK: - Methods -
    
    private func setupViewModelSearchingObserver() {
        
        viewModel.searchResult.bind { [weak self] users in
            
            guard let users = users else { return }
            self?.users = users
        }
    }
    
    
    
    private func setupSearchController() {
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
    }
    
    private func configureNavigationBar() {
        
        navigationController?.navigationItem.title = "Search"
        navigationController?.navigationBar.backgroundColor = view.backgroundColor
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.standardAppearance.backgroundColor = view.backgroundColor
    }
    
    
    func subscribeDelegate() {
        
       let vc = self.coordinator?.navigationController.topViewController as? ChatViewController
        self.delegate = vc
    }
    
    
    
    private func setupLayout() {
        
        view.addSubviews([searchImageView, descriptionLabel, tableView])
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
//            searchImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            searchImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            searchImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
//            searchImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
//
//            descriptionLabel.topAnchor.constraint(equalTo: searchImageView.bottomAnchor),
//            descriptionLabel.centerXAnchor.constraint(equalTo: searchImageView.centerXAnchor),
//            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
//
        ])
    }
    
    
    
    
    
    
    
//    private func setupConstraints() {
//
//        sharedConstraints.append(contentsOf: [
//
//            searchImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            searchImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.heightAnchor.constraint(equalTo: view.heightAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//
//            descriptionLabel.topAnchor.constraint(equalTo: searchImageView.bottomAnchor),
//            descriptionLabel.centerXAnchor.constraint(equalTo: searchImageView.centerXAnchor),
//            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
//
//        ])
//
//
//        portraitConstraints.append(contentsOf: [
//
//            searchImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            searchImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
//
//        ])
//
//
//        landscapeConstraints.append(contentsOf: [
//
//            searchImageView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
//            searchImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
//
//        ])
//
//        regxRegConstraints.append(contentsOf: [
//
//            searchImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
//            searchImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
//        ])
//    }
//
//
//    private func layoutTrait(traitCollection: UITraitCollection) {
//
//        if !sharedConstraints[0].isActive {
//
//            NSLayoutConstraint.activate(sharedConstraints)
//        }
//
//
//        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
//
//            if landscapeConstraints[0].isActive {
//
//                NSLayoutConstraint.deactivate(landscapeConstraints)
//            }
//            NSLayoutConstraint.activate(portraitConstraints)
//
//        } else if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .compact {
//
//            if portraitConstraints[0].isActive {
//
//                NSLayoutConstraint.deactivate(portraitConstraints)
//            }
//
//            NSLayoutConstraint.activate(landscapeConstraints)
//        } else {
//
//            NSLayoutConstraint.activate(regxRegConstraints)
//        }
//    }
}
