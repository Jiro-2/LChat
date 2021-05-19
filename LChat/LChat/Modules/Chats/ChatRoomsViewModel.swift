import Foundation
import Firebase


protocol ChatRoomsViewModelProtocol: class {
    
    var chatRooms: Bindable<[Chat]> { get }
    var currentUser: User? { get }
    
    func startObservingUserChatRooms()
    func getUserAvatarURL(_ username: String, completion: @escaping (URL?) -> ())
}


final class ChatRoomsViewModel: ChatRoomsViewModelProtocol {
    
    
    //MARK: - Properties -
    
   private let chatManager: FBChatServiceProtocol
   private let databaseService: FBDatabaseServiceProtocol
   private let storageService: FBStorageServiceProtocol
    
    var chatRooms = Bindable<[Chat]>()
    var currentUser: User?
    
    private var chatRoomsIDs = [String]() {
        
        willSet {
                        
            if let id = newValue.first {
                
                DispatchQueue.global(qos: .background).async {
                    
                    self.getChatBy(id: id) { chat in
                        
                        self.chatRooms.value?.append(chat)
                        self.observeMessagesIn(chat: chat)
                    }
                }
            }
        }
    }
    
    
    
    //MARK: - Init -
    
    init(chatManager: FBChatService, databaseService: FBDatabaseServiceProtocol, storageService: FBStorageServiceProtocol) {
        
        self.chatManager = chatManager
        self.databaseService = databaseService
        self.storageService = storageService
        
        self.chatRooms.value = []
        configCurrentUser()
    }
    
    //MARK: - Methods -
    

    
    func startObservingUserChatRooms() {
       
       guard let username = Auth.auth().currentUser?.displayName else { assertionFailure(); return }
       
        databaseService.observe(path: "userChats/\(username)", eventType: .childAdded) { [weak self] result in
           
           switch result {
           
           case .success(let data):
               
               guard let identifier = data as? String else { assertionFailure(); return }
               self?.chatRoomsIDs.append(identifier)
           
           case .failure(let error):
               
               assertionFailure(error.rawValue)
           }
       }
   }
    
    
   
    func getUserAvatarURL(_ username: String, completion: @escaping (URL?) -> ()) {
        
        storageService.getURL(from: "avatars/\(username)") { result in
            
            switch result {
            
            case .success(let url):
         
                completion(url)
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
    
   
    
    private func getChatBy(id: String,_ completion: @escaping (Chat) -> ()) {
        
        guard let currentUser = self.currentUser else { assertionFailure(); return }
        
        databaseService.getData(for: "chats/\(id)") { result in
            
            
            switch result {
            
            case .success(let data):
                
                guard let usernames = data as? [String] else { assertionFailure(); return }
                
                if let interlocutorName = usernames.first(where:)({ $0 != currentUser.username }) {
                    
                    self.getUser(ByName: interlocutorName) { user in
                        
                        guard let user = user else { return }
                        
                        let chat = Chat(id: id, members: [user, currentUser], messages: [])
                        completion(chat)
                    }
                }
            
            case .failure(let error):
                
                assertionFailure(error.rawValue)
            }
        }
    }
    
    

    
    private func getUser(ByName name: String, completion: @escaping (User?) -> ()) {
        
        databaseService.getData(for: "users/\(name)") { result in
            
            switch result {
            
            case .success(let data):
                
                guard let userDict = data as? [String:String],
                      let id = userDict["id"] else { assertionFailure(); return }
                
                let user = User(id: id, username: name, phone: userDict["phone"])
                completion(user)
                
            case .failure(let error):
                
                assertionFailure(error.rawValue)
                completion(nil)
            }
        }
    }
    
    
    
    private func observeMessagesIn(chat: Chat) {
        
        chatManager.startObserving(chatRoom: chat.id) { message in
            
            guard let message = message else { assertionFailure(); return }
                        
            if let index = self.chatRooms.value?.firstIndex(where:)({ $0.id == chat.id}) {
                
                self.chatRooms.value?[index].messages.append(message)
            }
        }
    }
    
    
    private func configCurrentUser () {
                
        guard let currentUser = Auth.auth().currentUser,
              let username = currentUser.displayName else { assertionFailure(); return }
        
        self.currentUser = User(id: currentUser.uid,
                                username: username,
                                phone: currentUser.phoneNumber)
        
    }
}
