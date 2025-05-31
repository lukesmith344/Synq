import Foundation
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var birthday: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    @Published var username: String = ""
    @Published var usernameAvailable: Bool? = nil
    @Published var contactsSynced: Bool = false
    @Published var matchedContacts: [String] = []
    
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
} 