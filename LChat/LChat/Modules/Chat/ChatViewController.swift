import UIKit
import MessageKit
import InputBarAccessoryView


final class ChatViewController: MessagesViewController {
    
    //MARK: - Properties -
    
    var viewModel: ChatViewModelProtocol
    var coordinator: MainCoordinator?
    var messages = [Message]()
    public let primaryColor = ThemeManager.shared.primaryColor
  
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
        
        view.backgroundColor = primaryColor

        setupDelegates()
        messagesCollectionView.messagesDataSource = self
        
        setupChatViewModelObserver()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageOutgoingAvatarSize(.zero)
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageIncomingAvatarSize(.zero)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
        configureInputBar()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.stopObservingChat()
        view.window?.overrideUserInterfaceStyle = UserDefaults.standard.interfaceStyle
    }


    
    //MARK: - Methods -
    
    private func configureInputBar() {
        
        messageInputBar.isTranslucent = false
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.tintColor = primaryColor
        messageInputBar.inputTextView.backgroundColor = #colorLiteral(red: 0.2580699335, green: 0.775914117, blue: 1, alpha: 0.1848429985)
        messageInputBar.inputTextView.placeholder = "Type your message"
        messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.6338604689, green: 0.6519217491, blue: 0.6755121946, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8,
                                                                        left: 16,
                                                                        bottom: 8,
                                                                        right: 36)
        
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8,
                                                                            left: 20,
                                                                            bottom: 8,
                                                                            right: 36)
        
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8,
                                                                           left: 0,
                                                                           bottom: 8,
                                                                           right: 0)
    }
    
    
    
    private func setupChatViewModelObserver() {
        
        viewModel.messages.bind { [weak self] messages in
            
            guard let messages = messages else { return }
            self?.messages = messages
            
            DispatchQueue.main.async {
                
                self?.messagesCollectionView.reloadData()
                self?.messagesCollectionView.scrollToLastItem()
            }
        }
    }
    
    
    
    
    private func configureNavBar() {
        
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance.backgroundColor = primaryColor
        navigationController?.navigationBar.tintColor = .white
        self.title = viewModel.interLocutor?.username
    }
    
    
    private func setupDelegates() {
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
}




//MARK: - Extension -

extension ChatViewController: ThemeObserver {
    
    func didChangePrimaryColor(_ color: UIColor) {
        
        navigationController?.navigationBar.standardAppearance.backgroundColor = color
        
    }
}
