import Foundation
import AuthenticationServices
import SwiftUI
import FirebaseAuth
import FirebaseMessaging

@MainActor
class AuthenticationService: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: UserProfile?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let profileService = UserProfileService()
    private var authStateListener: AuthStateDidChangeListenerHandle?
    private var appleSignInDelegate: SignInWithAppleDelegate? // Retain delegate
    
    init() {
        setupAuthStateListener()
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    private func setupAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            Task { @MainActor in
                if let firebaseUser = firebaseUser {
                    print("[Auth] Firebase user detected: \(firebaseUser.uid)")
                    await self?.handleUserSignIn(firebaseUser)
                } else {
                    print("[Auth] No Firebase user. Signed out.")
                    self?.handleUserSignOut()
                }
            }
        }
    }
    
    private func handleUserSignIn(_ firebaseUser: User) async {
        do {
            print("[Auth] Attempting to fetch user profile for UID: \(firebaseUser.uid)")
            try await profileService.fetchCurrentUser(uid: firebaseUser.uid)
            if let userProfile = profileService.currentUser {
                print("[Auth] User profile found: \(userProfile)")
                self.user = userProfile
                self.isAuthenticated = true
                // Subscribe to dailyDrop topic
                Messaging.messaging().subscribe(toTopic: "dailyDrop") { error in
                    if let error = error {
                        print("Failed to subscribe to dailyDrop: \(error)")
                    } else {
                        print("Subscribed to dailyDrop topic")
                    }
                }
            } else {
                print("[Auth] No user profile found. Should show onboarding.")
                self.isAuthenticated = false
                self.user = nil
            }
        } catch {
            print("[Auth] Error fetching user profile: \(error)")
            self.error = error
        }
    }
    
    private func handleUserSignOut() {
        print("[Auth] Signing out and clearing user state.")
        profileService.clearCurrentUser()
        self.user = nil
        self.isAuthenticated = false
        // Unsubscribe from dailyDrop topic
        Messaging.messaging().unsubscribe(fromTopic: "dailyDrop") { error in
            if let error = error {
                print("Failed to unsubscribe from dailyDrop: \(error)")
            } else {
                print("Unsubscribed from dailyDrop topic")
            }
        }
    }
    
    func signInWithApple() async throws {
        isLoading = true
        error = nil
        do {
            // Generate nonce for security
            let nonce = randomNonceString()
            currentNonce = nonce
            print("[SignIn] Starting Apple sign-in flow.")
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            let result = try await withCheckedThrowingContinuation { continuation in
                let controller = ASAuthorizationController(authorizationRequests: [request])
                let delegate = SignInWithAppleDelegate(continuation: continuation)
                self.appleSignInDelegate = delegate // Retain delegate
                controller.delegate = delegate
                controller.presentationContextProvider = delegate
                controller.performRequests()
            }
            if let appleIDCredential = result as? ASAuthorizationAppleIDCredential {
                print("[SignIn] AppleID credential received.")
                guard let identityToken = appleIDCredential.identityToken,
                      let idTokenString = String(data: identityToken, encoding: .utf8) else {
                    print("[SignIn] Invalid Apple identity token.")
                    self.appleSignInDelegate = nil // Release delegate
                    throw AuthError.invalidCredential
                }
                let credential = OAuthProvider.credential(
                    withProviderID: "apple.com",
                    idToken: idTokenString,
                    rawNonce: nonce
                )
                // Sign in to Firebase
                let authResult = try await Auth.auth().signIn(with: credential)
                print("[SignIn] Firebase sign-in successful: \(authResult.user.uid)")
                // The auth state listener will handle the rest
            }
            self.appleSignInDelegate = nil // Release delegate after completion
            isLoading = false
        } catch {
            print("[SignIn] Error during Apple sign-in: \(error)")
            self.appleSignInDelegate = nil // Release delegate on error
            self.error = error
            isLoading = false
            throw error
        }
    }
    
    func signOut() async throws {
        isLoading = true
        error = nil
        do {
            print("[SignOut] Attempting to sign out from Firebase.")
            try Auth.auth().signOut()
            print("[SignOut] Firebase sign-out successful.")
            // The auth state listener will handle clearing the user
            isLoading = false
        } catch {
            print("[SignOut] Error signing out: \(error)")
            self.error = error
            isLoading = false
            throw error
        }
    }
    
    // MARK: - User Profile Management
    
    /// Creates user profile after onboarding completion
    func createUserProfile(name: String, username: String, birthday: Date) async throws {
        guard let firebaseUser = Auth.auth().currentUser else {
            print("[Profile] No Firebase user found when creating profile.")
            throw AuthError.userNotFound
        }
        do {
            print("[Profile] Creating user profile in Firestore for UID: \(firebaseUser.uid)")
            try await profileService.createUserProfile(
                uid: firebaseUser.uid,
                name: name,
                username: username,
                birthday: birthday
            )
            print("[Profile] User profile created successfully.")
            // Update local user
            self.user = profileService.currentUser
            self.isAuthenticated = true
        } catch {
            print("[Profile] Error creating user profile: \(error)")
            self.error = error
            throw error
        }
    }
    
    // MARK: - Nonce Management for Apple Sign In
    
    private var currentNonce: String?
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

// MARK: - Custom Errors

enum AuthError: Error, LocalizedError {
    case invalidCredential
    case userNotFound
    
    var errorDescription: String? {
        switch self {
        case .invalidCredential:
            return "Invalid credential provided"
        case .userNotFound:
            return "User not found"
        }
    }
}

// MARK: - SHA256 Extension

import CryptoKit

extension SHA256 {
    static func hash(data: Data) -> Data {
        let hash = SHA256.hash(data: data)
        return Data(hash)
    }
}

private class SignInWithAppleDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    let continuation: CheckedContinuation<ASAuthorization, Error>
    
    init(continuation: CheckedContinuation<ASAuthorization, Error>) {
        self.continuation = continuation
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window available")
        }
        return window
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        continuation.resume(returning: authorization)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation.resume(throwing: error)
    }
} 