import UIKit

final class LanguagesViewController: UIViewController {
    
    //MARK: - Properties -
    
    private let viewModel: LanguagesViewModelProtocol
    private lazy var tableView = UITableView(frame: view.frame)
    
    
    //MARK: - Init -
    
    init(viewModel: LanguagesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: -Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
      //  overrideUserInterfaceStyle = UserDefaults.standard.interfaceStyle
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}



//MARK: - Extension -


extension LanguagesViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        viewModel.languages.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.textLabel?.text = viewModel.languages[indexPath.row]
        
        if let lang = viewModel.currentLang {
            
            if lang == viewModel.languages[indexPath.row] {
                
                cell.accessoryType = .checkmark
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let currentLang = viewModel.currentLang,
              let indexCurrentLang = viewModel.languages.firstIndex(of: currentLang) else { assertionFailure(); return }
        
        let currentLangCell = tableView.cellForRow(at: IndexPath(row: indexCurrentLang, section: 0))
        currentLangCell?.accessoryType = .none
        

        viewModel.set(viewModel.languages[indexPath.row])
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = .checkmark
        tableView.moveRow(at: indexPath, to: [0,0])

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}


