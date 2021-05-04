import UIKit

class HomeTabBarController: UITabBarController {

    //MARK: - Properties -
    
    var viewModel: HomeViewModelProtocol
    var coordinator: MainCoordinator?
    
    
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.window?.overrideUserInterfaceStyle = UserDefaults.standard.interfaceStyle
    }

    
    //MARK: - Methods -
    
    private func configureNavBar() {
        
        self.title = "LChat"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBarButtonItemDidTap))
    }
    

    
    @objc
    private func searchBarButtonItemDidTap() {
        
        viewModel.search()
        coordinator?.showSearch()
    }
}
