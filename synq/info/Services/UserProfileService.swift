import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

@MainActor
class UserProfileService: ObservableObject {
    private let db = Firestore.firestore()
    private let usersCollection = "users"
    
    @Published var currentUser: UserProfile?
    @Published var isLoading = false
    @Published var error: Error?
    
    // MARK: - User Creation and Management
    
    /// Creates a new user profile in Firestore after Apple sign-in and onboarding completion
    /// Only creates the user if one doesn't already exist
    func createUserProfile(uid: String, name: String, username: String, birthday: Date) async throws {
        isLoading = true
        error = nil
        
        do {
            // Check if user already exists
            let userDoc = try await db.collection(usersCollection).document(uid).getDocument()
            
            if userDoc.exists {
                // User already exists, fetch and update current user
                if let userData = userDoc.data(),
                   let userProfile = try? UserProfile.fromFirestore(userData, id: uid) {
                    currentUser = userProfile
                }
                isLoading = false
                return
            }
            
            // Create new user profile
            let newUser = UserProfile(
                id: uid,
                uid: uid,
                name: name,
                username: username,
                birthday: birthday,
                onboardingComplete: true
            )
            
            // Save to Firestore
            try await db.collection(usersCollection).document(uid).setData(newUser.toFirestore())
            
            // Update current user
            currentUser = newUser
            isLoading = false
            
        } catch {
            self.error = error
            isLoading = false
            throw error
        }
    }
    
    /// Fetches the current user profile from Firestore
    func fetchCurrentUser(uid: String) async throws {
        isLoading = true
        error = nil
        
        do {
            let userDoc = try await db.collection(usersCollection).document(uid).getDocument()
            
            if userDoc.exists, let userData = userDoc.data() {
                currentUser = try UserProfile.fromFirestore(userData, id: uid)
            } else {
                currentUser = nil
            }
            
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            throw error
        }
    }
    
    /// Updates the current user profile
    func updateUserProfile(_ user: UserProfile) async throws {
        isLoading = true
        error = nil
        
        do {
            try await db.collection(usersCollection).document(user.id).setData(user.toFirestore())
            currentUser = user
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            throw error
        }
    }
    
    /// Deletes the current user profile
    func deleteUserProfile(uid: String) async throws {
        isLoading = true
        error = nil
        
        do {
            try await db.collection(usersCollection).document(uid).delete()
            currentUser = nil
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            throw error
        }
    }
    
    /// Clears the current user (for sign out)
    func clearCurrentUser() {
        currentUser = nil
        error = nil
    }
}

// MARK: - UserProfile Firestore Extensions

extension UserProfile {
    /// Converts UserProfile to Firestore data
    func toFirestore() -> [String: Any] {
        return [
            "uid": uid,
            "name": name,
            "username": username,
            "birthday": birthday,
            "createdAt": createdAt,
            "onboardingComplete": onboardingComplete
        ]
    }
    
    /// Creates UserProfile from Firestore data
    static func fromFirestore(_ data: [String: Any], id: String) throws -> UserProfile {
        guard let uid = data["uid"] as? String,
              let name = data["name"] as? String,
              let username = data["username"] as? String,
              let birthday = data["birthday"] as? Timestamp,
              let createdAt = data["createdAt"] as? Timestamp,
              let onboardingComplete = data["onboardingComplete"] as? Bool else {
            throw FirestoreError.invalidData
        }
        
        return UserProfile(
            id: id,
            uid: uid,
            name: name,
            username: username,
            birthday: birthday.dateValue(),
            onboardingComplete: onboardingComplete
        )
    }
}

// MARK: - Custom Errors

enum FirestoreError: Error, LocalizedError {
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Invalid data received from Firestore"
        }
    }
} 