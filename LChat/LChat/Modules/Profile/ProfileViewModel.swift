import Foundation
import Firebase

protocol ProfileViewModelProtocol {
    
    var user: Bindable<User> { get set }
    var oldModelUser: User? { get }
    var isChanged: Bool { get set }
    
    func uploadAvatarImage(ImageData data: Data)
    func getUserAvatarImageURL(completion: @escaping (URL?) -> ())
    func observeDataProfile()
    func updateProfile()
}


final class ProfileViewModel: ProfileViewModelProtocol {
    
    //MARK: - Properties -
    
    private let storageService: FBStorageServiceProtocol
    private let databaseService: FBDatabaseServiceProtocol
    
    var isChanged = false {
        
        willSet {
            
            if newValue {
                
                oldModelUser = user.value
            } else {
                
                oldModelUser = nil
            }
        }
    }
    
    var oldModelUser: User?
    var user =  Bindable<User>()
    
    
    //MARK: - Init -
    
    init(storageService: FBStorageServiceProtocol, databaseService: FBDatabaseServiceProtocol) {
        
        self.storageService = storageService
        self.databaseService = databaseService
        
    }
    
    
    //MARK: - Methods -
    
    
    func updateProfile() {
        
        if isChanged {
            
            guard let user = user.value else { return }
            let mirror = Mirror(reflecting: user)
            var dict = [String:Any]()
            
            
            for child in mirror.children {
                
                if child.label == "username" {
                    continue
                }
                
                guard let key = child.label else { assertionFailure(); return }
                dict[key] = child.value
            }
            
            
            databaseService.put(dict, in: "users/\(user.username)") { error in
                
                if let error = error {
                    
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
    
    
    
    
    func observeDataProfile() {
        
        if let username = Auth.auth().currentUser?.displayName {
            
            databaseService.observe(path: "users/\(username)", eventType: .value) { [weak self] result in
                
                
                switch result {
                
                case .success(let data):
                    
                    guard let data = data as? [String:String],
                          let id = data["id"] else { assertionFailure(); return }
                    
                    self?.user.value = User(id: id,
                                            username: username,
                                            location: data["location"],
                                            phone: data["phone"],
                                            bio: data["bio"])
                    
                    
                case .failure(let error):
                    
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
    
    
    
    
    func getUserAvatarImageURL(completion: @escaping (URL?) -> ()) {
        
        if let username = Auth.auth().currentUser?.displayName {
            
            self.storageService.getURL(from: "avatars/\(username)") { result in
                
                switch result {
                
                case .failure(let error):
                    
                    print("ERROR: ", error.localizedDescription)
                    completion(nil)
                    
                case .success(let url):
                    
                    completion(url)
                }
            }
        }
    }
    
    
    
    
    func uploadAvatarImage(ImageData data: Data) {
        
        guard let username = Auth.auth().currentUser?.displayName else { assertionFailure(); return }
        self.storageService.upload(data: data, path: "avatars/\(username)")
    }
}
