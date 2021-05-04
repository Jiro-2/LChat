import Foundation

struct User: Identifiable {
    
    let id: String
    var username: String
    var location: String?
    var phone: String?
    var bio: String?
}
