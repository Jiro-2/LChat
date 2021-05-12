

import Foundation

protocol SearchUserViewModelProtocol: class {
    
    var searchResult: Bindable<[User]> { get set }
    
    func searchUserBy(_ username: String?)
}


final class SearchUserViewModel: SearchUserViewModelProtocol {
    
    //MARK: - Properties -
    
    private var searcher: FBSearchable
    var searchResult = Bindable<[User]>()
    
    
    //MARK: - Init -
    
    init(databaseSearcher: FBSearchable) {
        searcher = databaseSearcher
        searchResult.value = [User]()
    }
    
    
    //MARK: - Methods -
    
    
    func searchUserBy(_ username: String?) {
        
        if let username = username {
            
            if username.count >= 3 {
                
                self.searcher.search(username, in: .username) { [weak self] result in
                    
                    let dictResult = result as? [String: Any]
                    var users = [User]()
                    
                    dictResult?.forEach({ key, value in
                        
                        guard let dict = value as? [String:String],
                              let phone = dict["phone"],
                              let id = dict["id"] else { assertionFailure(); return } // MARK: FIX as String
                        
                        let user = User(id: id, username: key, phone: phone)
                        users.append(user)
                    })
                    
                    self?.searchResult.value = users
                }
                
            } else {
                
                self.searchResult.value = []
            }
        }
    }
}
