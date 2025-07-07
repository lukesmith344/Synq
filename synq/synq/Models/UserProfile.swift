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
    var onboardingComplete: Bool
    
    init(id: String, displayName: String? = nil, email: String? = nil, username: String? = nil, birthday: Date? = nil, onboardingComplete: Bool = false) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.dateCreated = Date()
        self.username = username
        self.birthday = birthday
        self.lastLoginDate = Date()
        self.onboardingComplete = onboardingComplete
    }
    
    mutating func updateOnboarding(name: String, birthday: Date, username: String) {
        self.displayName = name
        self.birthday = birthday
        self.username = username
        self.onboardingComplete = true
    }
} 