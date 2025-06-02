import Foundation

class UserProfileService: ObservableObject {
    @Published private(set) var currentProfile: UserProfile?
    private let userDefaultsKey = "currentUserProfile"
    
    init() {
        loadProfile()
    }
    
    private func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            DispatchQueue.main.async {
                self.currentProfile = profile
            }
        }
    }
    
    func saveProfile(_ profile: UserProfile) {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            DispatchQueue.main.async {
                self.currentProfile = profile
            }
        }
    }
    
    func updateProfile(displayName: String? = nil, email: String? = nil, username: String? = nil, birthday: Date? = nil) {
        guard var profile = currentProfile else { return }
        
        if let displayName = displayName { profile.displayName = displayName }
        if let email = email { profile.email = email }
        if let username = username { profile.username = username }
        if let birthday = birthday { profile.birthday = birthday }
        
        profile.lastLoginDate = Date()
        saveProfile(profile)
    }
    
    func clearProfile() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        DispatchQueue.main.async {
            self.currentProfile = nil
        }
    }
} 