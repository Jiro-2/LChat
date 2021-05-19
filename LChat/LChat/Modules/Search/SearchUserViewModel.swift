

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
                    
                    guard let dictResult = result as? [String:String] else { return }
                                        
                    guard let id = dictResult["id"],
                          let phone = dictResult["phone"] else { assertionFailure(); return }
                    
                    let user = User(id: id, username: username, phone: phone)
                    self?.searchResult.value = [user]
                }
                
            } else {
                
                self.searchResult.value = []
            }
        }
    }
}
