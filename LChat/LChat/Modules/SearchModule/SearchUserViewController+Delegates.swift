import UIKit

extension SearchUserViewController:  UISearchBarDelegate {
    
//    func updateSearchResults(for searchController: UISearchController) {
//        
//    }
//    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        viewModel.searchUserBy(searchBar.text)
    }
    

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        isSearching = true
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        isSearching = false
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
     
        viewModel.searchResult.value = []
        isSearching = false
    }
}





extension SearchUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  users.count
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let userCell = cell as? UserTableViewCell
        
        let userName = users[indexPath.row].username
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



