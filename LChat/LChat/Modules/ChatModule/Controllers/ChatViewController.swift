//
//  ChatViewController.swift
//  LingoChat
//
//  Created by Егор on 15.02.2021.


import UIKit
import MessageKit
import InputBarAccessoryView


final class ChatViewController: MessagesViewController {
    
    //MARK: - Properties -
    
    var viewModel: ChatViewModelProtocol
    var currentUserID: String?
    var member: User?
    var messages = [Message]() {
        
        didSet {
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToLastItem(animated: true)
        }
    }
    
    
    //MARK: - Subviews
    
    
    private lazy var startChatButton: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Start Chat", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.3123230934, green: 0.7254405618, blue: 0.6899064779, alpha: 1), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .bold)
        btn.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
        
        return btn
    }()
    
    @objc
    private func startButtonDidTap() {
        
        if let member = self.member {
            viewModel.startChat(with: member)
            self.startChatButton.isHidden = true
            self.inputAccessoryView?.isHidden = false
        }
    }
    
    
    //MARK: - Init -
    
    init(viewModel: ChatViewModelProtocol) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.2615707219, green: 0.6179133654, blue: 0.5889353752, alpha: 1)
        
        messagesCollectionView.messagesDataSource = self
        setupDelegates()
        
        getSelectedChat()
        checkChatExistenceWithSelectedUser()
        setupChatViewModelObserver()
        
        currentUserID = viewModel.getCurrentSenderID()
        
        view.addSubviews([startChatButton])
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupLayout()
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageOutgoingAvatarSize(.zero)
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageIncomingAvatarSize(.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
        configureInputBar()
    }
    
    
    
    
    //MARK: - Methods -
    
    private func configureInputBar() {
        
        messageInputBar.isTranslucent = false
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.tintColor = .primaryColor
        messageInputBar.inputTextView.backgroundColor = #colorLiteral(red: 0.2580699335, green: 0.775914117, blue: 1, alpha: 0.1848429985)
        messageInputBar.inputTextView.placeholder = "Type your message"
        messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.6338604689, green: 0.6519217491, blue: 0.6755121946, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    
    
    private func getSelectedChat() {
        
        if let tabBarController = navigationController?.previousViewController() as? UITabBarController,
           let chatListViewController = tabBarController.selectedViewController as? ChatListViewController {
            
            member = chatListViewController.viewModel.selectedChat?.member
            viewModel.currentChat.value = chatListViewController.viewModel.selectedChat
            
            viewModel.getMessages() // ????????
            viewModel.setObserve()
        }
    }
    
    
    
    private func checkChatExistenceWithSelectedUser() {
        
        if let vc = navigationController?.previousViewController() as? SearchUserViewController {
            
            if let selectedUser = vc.viewModel.selectedUser {
                
                member = selectedUser
                
                viewModel.checkExistenceChatWith(user: selectedUser) { isExist in
                    
                    if isExist {
            
                        self.startChatButton.isHidden = true
                        
                    } else {
                        
                        self.startChatButton.isHidden = false
                        self.inputAccessoryView?.isHidden = true
                    }
                }
            }
        }
    }
    
    
    private func setupChatViewModelObserver() {
        
        viewModel.currentChat.bind { [weak self] chat in
            
            guard let self = self else { return }
            
            self.messages = chat?.messages ?? []
        }
    }
    
    
    
    private func configureNavBar() {
        
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.primaryColor
        navigationController?.navigationBar.tintColor = .white
        self.title = member?.userName
    }
    
    
    private func setupDelegates() {
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            
            startChatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startChatButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}




//MARK: - Extensions -


//MARK: DataSource
extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        
        var userID = ""
        if let id = currentUserID {
            userID = id
        }
        
        assert(!userID.isEmpty, "Setup SenderType in MessagesDataSource failed, because id of current user is empty")
        
        return Sender(senderId: userID, displayName: "")
    }
    
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.gray,
                          NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11.0, weight: .medium)]
        
        let date = messages[indexPath.section].date
        let format = "yyyy-MM-dd HH:mm"
        let formatter = DateFormatter()
        
        
        if formatter.isToday(date: date, withFormat: format) {
            
            if let convertedStrDateToHour = formatter.convertDate(string: date, fromFormat: format, toFormat: "HH:mm") {
                
                return  NSAttributedString(string: convertedStrDateToHour, attributes: attributes)
            }
        }
        
        if formatter.isYesterday(date: date, format: format),
           let convertedStrDate = formatter.convertDate(string: date, fromFormat: format, toFormat: "HH:mm") {
            
            let text = "yesterday \(convertedStrDate)"
            return  NSAttributedString(string: text, attributes: attributes)
            
        } else {
            
            let convertedStrDate = formatter.convertDate(string: date, fromFormat: format, toFormat: "MMM dd HH:mm")
            
            return  NSAttributedString(string: convertedStrDate!, attributes: attributes)
        }
    }
}



//MARK: Delegates


extension ChatViewController: MessagesDisplayDelegate {
    
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        let borderColor: UIColor = isFromCurrentSender(message: message) ? .clear : .clear
        return .bubbleTailOutline(borderColor, corner, .pointedEdge)
    }
    
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 20.0
    }
}




extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        if !text.isEmpty {
            
            if let id = currentUserID {
                
                viewModel.sendMessageBy(user: User(id: id, userName: ""), text: text) { error in
                    
                    if let _ = error {
                        
                        print("Show failed sending in UI")
                        
                    } else {
                        inputBar.inputTextView.text = ""
                    }
                }
            }
        }
    }
}




extension ChatViewController: MessagesLayoutDelegate {
    
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        let colorOfUserMessages = UIColor(red: 0.2815505862, green: 0.6601088643, blue: 0.6278207302, alpha: 1.0)
        let colorOfMemberMessages = UIColor(red: 0.9078431726, green: 0.9589278102, blue: 0.9659121633, alpha: 1)
        
        return  isFromCurrentSender(message: message) ? colorOfUserMessages : colorOfMemberMessages
    }
}
