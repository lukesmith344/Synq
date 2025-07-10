import Foundation
import Combine

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var birthday: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    @Published var username: String = ""
    @Published var usernameAvailable: Bool? = nil
    @Published var contactsSynced: Bool = false
    @Published var matchedContacts: [String] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    let authService: AuthenticationService
    
    init(authService: AuthenticationService) {
        self.authService = authService
    }
    
    // Mock username check
    func checkUsernameAvailability() {
        // Simulate async check
        let taken = ["alex", "luke", "musicfan"]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.usernameAvailable = !taken.contains(self.username.lowercased()) && self.username.count >= 3 && !self.username.contains(" ")
        }
    }
    
    // Mock contacts sync
    func syncContacts() {
        // Simulate permission and matching
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.contactsSynced = true
            self.matchedContacts = ["Taylor Swift", "Drake", "Phoebe Bridgers"]
        }
    }
    
    func completeOnboarding() async throws {
        guard !name.isEmpty, !username.isEmpty else {
            throw OnboardingError.invalidData
        }
        
        isLoading = true
        error = nil
        
        do {
            // Create user profile in Firestore
            try await authService.createUserProfile(
                name: name,
                username: username,
                birthday: birthday
            )
            
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            throw error
        }
    }
}

// MARK: - Custom Errors

enum OnboardingError: Error, LocalizedError {
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Please fill in all required fields"
        }
    }
} 