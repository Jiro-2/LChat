import UIKit

protocol CountriesViewControllerDelegate: class {
    
    func viewController(_ viewController: UIViewController, didSelect country: Country)
}


class CountriesViewController: UITableViewController {
    
    //MARK: - Properties -
    
    var viewModel: CountriesViewModelProtocol
    var coordinator: AuthCoordinator?
    weak var delegate: CountriesViewControllerDelegate?
    var countries: [Character:[Country]]?
    
    
    //MARK: - Init -
    
    
    init(viewModel: CountriesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries = viewModel.getCountries()
        subscribeDelegate()
    }
    
    //MARK: - Methods -
    
    
    func subscribeDelegate() {
       
        if let vc = self.coordinator?.navigationController.topViewController {
            
            if let loginVC = vc as? LoginViewController {
                

                delegate = loginVC
            }
            
            if let signUp = vc as? SignUpViewController {
                
                delegate = signUp
            }
        }
    }
    
    
   
    //MARK: - Table -
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let key = viewModel.alphabet[indexPath.section]
    
        if let countries = countries?[key] {
            
            dismiss(animated: true) {
                
                self.delegate?.viewController(self, didSelect: countries[indexPath.row])
            }
        }
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let key = viewModel.alphabet[indexPath.section]
        
        if let countries = self.countries?[key],
           let flag = countries[indexPath.row].flag,
           let name = countries[indexPath.row].name {
            
            cell.textLabel?.text = flag + " " + name
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 26
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var amountOfCountries: Int
        
        if let countries = countries {
            
            let key = viewModel.alphabet[section]
            amountOfCountries = countries[key]?.count ?? 0
            
        } else {
            
            amountOfCountries = 0
        }
        
        return amountOfCountries
    }
    
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        viewModel.alphabet.map() { "\($0)" }
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
                
        return String(viewModel.alphabet[section]).uppercased()
    }
}
