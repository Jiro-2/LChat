//
//  ChatsListViewController.swift
//  LingoChat
//
//  Created by Егор on 01.03.2021.


import UIKit

class ChatListViewController: UIViewController {
    
    //MARK: - Properties -
    
    var viewModel: ChatListViewModelProtocol
    var chatRooms: [Chat]? {
        
        didSet {
            chatRoomsTableView.reloadData()
        }
    }
    
    
    //MARK: - Subviews
    
    private lazy var chatRoomsTableView: UITableView = {
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatCellID")
        
        return tableView
    }()
    
    
    //MARK: - Init -
    
    
    init(viewModel: ChatListViewModelProtocol) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubviews([chatRoomsTableView])
        
        chatRoomsTableView.delegate = self
        chatRoomsTableView.dataSource = self
        
        setupChatListViewModelObserver()
        viewModel.getChatRooms()
        viewModel.observeChats()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
   
    
    //MARK: - Methods -
    
    
    private func setupChatListViewModelObserver() {
        
        viewModel.chats.bind { [weak self] chats in
            
            self?.chatRooms = chats
        }
    }
    
    
    
    private func configureNavBar() {
               
        navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.primaryColor
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


extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        chatRooms?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let chat = chatRooms?[indexPath.row] {
            
            viewModel.selectChat(chat)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCellID") as? ChatTableViewCell
        return cell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let chatCell = cell as? ChatTableViewCell
        
        guard let chatRooms = chatRooms else { return }
        
        viewModel.downloadMessages(fromChat: chatRooms[indexPath.row].id, limit: 100)

        
        chatCell?.userNameLabel.text = chatRooms[indexPath.row].member.userName
        chatCell?.lastMessageLabel.text = chatRooms[indexPath.row].lastMessage
        
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
