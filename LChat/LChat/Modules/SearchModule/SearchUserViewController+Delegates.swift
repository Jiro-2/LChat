//
//  SearchUserViewController+Delegates.swift
//  LChat
//
//  Created by Егор on 04.04.2021.
//

import UIKit

extension SearchUserViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        (searchController.searchBar.value(forKey: "searchField") as? UITextField)?.textColor = .white
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        viewModel.searchUserBy(searchBar.text)
    }
    
    

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if tableView.isHidden {
            tableView.isHidden = false
        }
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
     
        viewModel.searchResult.value = []
        tableView.isHidden = true
    }
}





extension SearchUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  users.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let userCell = cell as? UserTableViewCell
        
        let userName = users[indexPath.row].userName
        userCell?.userNameLabel.text = userName
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       return  tableView.dequeueReusableCell(withIdentifier: "userCellID") as? UserTableViewCell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.coordinator?.showChat()
        self.subscribeDelegate()
        self.delegate?.viewController(self, foundUser: users[indexPath.row])
    }
}



