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
    func navigateToChat(_ user: User)
}


final class SearchUserViewModel: SearchUserViewModelProtocol {
    
    //MARK: - Properties
    
    private var databaseSearcher: DatabaseSearchable
    var selectedUser: User? = nil
    var searchResult = Bindable<[User]>()


    //MARK: - Init
    
    init(databaseSearcher: DatabaseSearchable) {
        self.databaseSearcher = databaseSearcher
    }
    
    
    //MARK: - Methods
    
    func navigateToChat(_ user: User) {
        
    }
    
    
    func searchUserBy(_ username: String?) {
        
        if let username = username {
            
            if username.count >= 2 {
                
                databaseSearcher.searchBy(category: .userName, word: username, completionHandler: { [weak self] result in
                    
                    guard let self = self else { return }
                    guard let foundUsers = result as? [User] else { return }
                    
                    self.searchResult.value = foundUsers.sorted { $0.userName < $1.userName }
                })
            }
        }
    }
}
