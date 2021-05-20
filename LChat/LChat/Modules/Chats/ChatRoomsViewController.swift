import UIKit
import SDWebImage

protocol ChatRoomsViewControllerDelegate: class {
    
    func viewController(_ viewController: ChatRoomsViewController, didSelect chat: Chat)
}


final class ChatRoomsViewController: UIViewController {
    
    //MARK: - Properties -
    
    let viewModel: ChatRoomsViewModelProtocol
    weak var delegate: ChatRoomsViewControllerDelegate?
    
    
    //MARK: - Subviews -
    
    private lazy var chatRoomsTableView: UITableView = {
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatCellID")
        
        return tableView
    }()
    
    
    
    //MARK: - Init -

    init(viewModel: ChatRoomsViewModelProtocol) {
        
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
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubviews([chatRoomsTableView])
        
        ThemeManager.shared.addObserver(self)
        
        chatRoomsTableView.delegate = self
        chatRoomsTableView.dataSource = self
        
        setupChatListViewModelObserver()
        
        DispatchQueue.global(qos: .background).async {
            
            self.viewModel.startObservingUserChatRooms()
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayout()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.window?.overrideUserInterfaceStyle = UserDefaults.standard.interfaceStyle
    }

   
    
    //MARK: - Methods -
    
    
    private func setupChatListViewModelObserver() {
        
        viewModel.chatRooms.bind { [weak self] chats in
            
            DispatchQueue.main.async {
                
                self?.chatRoomsTableView.reloadData()
            }
        }
    }
    
    
    
    private func configureNavBar() {
               
        navigationController?.navigationBar.standardAppearance.backgroundColor = ThemeManager.shared.primaryColor
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor : UIColor.white,
                                                                                      .font : UIFont.systemFont(ofSize: 25.0, weight: .semibold)]
    }
    
    
    
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            
            chatRoomsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatRoomsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatRoomsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chatRoomsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


//MARK: - Extension -


extension ChatRoomsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        viewModel.chatRooms.value?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let chat = viewModel.chatRooms.value?[indexPath.row],
           let tabbar = tabBarController as? HomeTabBarController {
            
            tabbar.coordinator?.showChat()
           let vc = tabbar.coordinator?.navigationController.topViewController as? ChatViewController
            delegate = vc
            delegate?.viewController(self, didSelect: chat)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCellID") as? ChatTableViewCell
        return cell ?? UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let chatRooms = viewModel.chatRooms.value else { return }
        let chatCell = cell as? ChatTableViewCell
        let interlocutor = chatRooms[indexPath.row].interlocutors.interlocutor
        
        
        chatCell?.usernameLabel.text = "\(interlocutor.username)"
        
        viewModel.getUserAvatarURL(interlocutor.username) { url in
            
            chatCell?.avatarImageView.sd_setImage(with: url)
        }
        
    
        if let lastMessage = chatRooms[indexPath.row].lastMessage {
            
            chatCell?.lastMessageLabel.text = lastMessage
        }
        

        if let count = chatRooms[indexPath.row].countUnSeenMessages {

            if count > 0 {

                chatCell?.unSeenMessagesLabel.text = "\(count)"
                chatCell?.unSeenMessagesLabel.isHidden = false
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? 150 : 70
    }
}



extension ChatRoomsViewController: ThemeObserver {
    
    func didChangePrimaryColor(_ color: UIColor) {
        
        navigationController?.navigationBar.standardAppearance.backgroundColor = color
    }
}
