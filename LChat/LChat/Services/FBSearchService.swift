import Foundation
import Firebase


enum SearchCategory: String {
    
    case username
    case phone
}



protocol FBSearchable {
    
    func search(_ query: String, in category: SearchCategory, completion: @escaping (Any?) -> ())
    func searchChat(WithUser user: User, completion: @escaping () -> ())
}


final class FBSearchService: FBSearchable {
    
    private let databaseReference = Database.database(url: "https://lchat-9bb0e-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    
    
    
    
    func searchChat(WithUser user: User, completion: @escaping () -> ()) {
        
        guard let user = Auth.auth().currentUser?.displayName else { return }
        
        databaseReference.child("userChats").child(user).observeSingleEvent(of: .value) { snap in
            
            if snap.exists() {
                
                let dict = snap.value as? [String:String]
                
            }
        }
    }

    
    
    func search(_ query: String, in category: SearchCategory, completion: @escaping (Any?) -> ()) {
        
        var dbQuery: DatabaseQuery
        
        switch category {
        
        case .username:
            
            dbQuery = databaseReference
                .child("users/\(query)")

        case .phone:
            
            dbQuery = databaseReference
                .child("users")
                .queryOrdered(byChild: category.rawValue)
                .queryStarting(atValue: query)
                .queryEnding(atValue: query + "\u{f8ff}")
        }
        

        dbQuery.observeSingleEvent(of: .value) { snap in
            
            if snap.exists() {
                
                completion(snap.value)
                
            } else {
                
                completion(nil)
            }
        }
    }
}
