//
//  SearchUserViewModel.swift
//  LingoChat
//
//  Created by Егор on 14.02.2021.
//

import Foundation

protocol SearchUserViewModelProtocol: class {
    
    var selectedUser: User? { get set }
    var searchResult: Bindable<[User]> { get set }
    
    func searchUserBy(_ username: String?)
}


final class SearchUserViewModel: SearchUserViewModelProtocol {
    
    //MARK: - Properties -
    
    private var searcher: FBSearchable
    var selectedUser: User? = nil
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
                              let username = dict["username"] else { assertionFailure(); return }
                        
                        let user = User(id: key, userName: username)
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
