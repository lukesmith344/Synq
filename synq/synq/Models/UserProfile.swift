import Foundation

struct UserProfile: Codable, Identifiable {
    let id: String // Apple user ID
    var displayName: String?
    var email: String?
    let dateCreated: Date
    var username: String?
    var birthday: Date?
    var profileImageURL: String?
    var lastLoginDate: Date
    
    init(id: String, displayName: String? = nil, email: String? = nil, username: String? = nil, birthday: Date? = nil) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.dateCreated = Date()
        self.username = username
        self.birthday = birthday
        self.lastLoginDate = Date()
    }
} 