//
//  HomeTabBarController.swift
//  LingoChat
//
//  Created by Егор on 02.03.2021.
//

import UIKit

class HomeTabBarController: UITabBarController {

    //MARK: - Properties -
    
    var viewModel: HomeViewModelProtocol
    
    
    
    //MARK: - Init -
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    
    
    
    //MARK: - Methods -
    
    private func configureNavBar() {
        
        self.title = "LingoChat"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBarButtonItemDidTap))
    }
    

    
    @objc
    private func searchBarButtonItemDidTap() {
        viewModel.search()
    }
}
