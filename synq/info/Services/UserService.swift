import Foundation
import FirebaseFirestore

@MainActor
class UserService: ObservableObject {
    private let db = Firestore.firestore()
    private let usersCollection = "users"

    // Fetch or create user profile after sign in
    func fetchOrCreateUserProfile(uid: String, name: String, username: String, birthday: Date) async throws -> UserProfile {
        let docRef = db.collection(usersCollection).document(uid)
        let doc = try await docRef.getDocument()
        if let data = doc.data() {
            // User exists, decode and return
            let jsonData = try JSONSerialization.data(withJSONObject: data)
            let profile = try JSONDecoder().decode(UserProfile.self, from: jsonData)
            return profile
        } else {
            // User does not exist, create new profile
            let newProfile = UserProfile(id: uid, uid: uid, name: name, username: username, birthday: birthday)
            try docRef.setData(from: newProfile)
            return newProfile
        }
    }
} 