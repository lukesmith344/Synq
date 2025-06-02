import Foundation
import AuthenticationServices
import SwiftUI

class AuthenticationService: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: UserProfile?
    private let profileService = UserProfileService()
    
    init() {
        // Check for existing session on launch
        if let profile = profileService.currentProfile {
            self.user = profile
            self.isAuthenticated = true
        }
    }
    
    func signInWithApple() async throws {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let result = try await withCheckedThrowingContinuation { continuation in
            let controller = ASAuthorizationController(authorizationRequests: [request])
            let delegate = SignInWithAppleDelegate(continuation: continuation)
            controller.delegate = delegate
            controller.presentationContextProvider = delegate
            controller.performRequests()
        }
        
        if let appleIDCredential = result as? ASAuthorizationAppleIDCredential {
            let userId = appleIDCredential.user
            let email = appleIDCredential.email
            let name = appleIDCredential.fullName?.formatted()
            
            // Create or update user profile
            let profile = UserProfile(
                id: userId,
                displayName: name,
                email: email
            )
            
            profileService.saveProfile(profile)
            
            DispatchQueue.main.async {
                self.user = profile
                self.isAuthenticated = true
            }
        }
    }
    
    func signOut() {
        profileService.clearProfile()
        DispatchQueue.main.async {
            self.user = nil
            self.isAuthenticated = false
        }
    }
}

private class SignInWithAppleDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    let continuation: CheckedContinuation<ASAuthorization, Error>
    
    init(continuation: CheckedContinuation<ASAuthorization, Error>) {
        self.continuation = continuation
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.windows.first!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        continuation.resume(returning: authorization)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation.resume(throwing: error)
    }
} 