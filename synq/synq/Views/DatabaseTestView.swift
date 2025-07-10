import SwiftUI
import FirebaseAuth

struct DatabaseTestView: View {
    @ObservedObject var authService: AuthenticationService
    @State private var testMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Firestore Integration Test")
                .font(.title)
                .fontWeight(.bold)
            
            if let user = authService.user {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Current User:")
                        .font(.headline)
                    Text("ID: \(user.id)")
                    Text("Name: \(user.name)")
                    Text("Username: \(user.username)")
                    Text("Onboarding Complete: \(user.onboardingComplete ? "Yes" : "No")")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            } else {
                Text("No user profile found")
                    .foregroundColor(.red)
            }
            
            if let firebaseUser = Auth.auth().currentUser {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Firebase Auth User:")
                        .font(.headline)
                    Text("UID: \(firebaseUser.uid)")
                    Text("Email: \(firebaseUser.email ?? "No email")")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            } else {
                Text("No Firebase user found")
                    .foregroundColor(.red)
            }
            
            if !testMessage.isEmpty {
                Text(testMessage)
                    .foregroundColor(.green)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            Button("Test User Creation") {
                testUserCreation()
            }
            .disabled(isLoading)
            .padding()
            .background(Color("FreshMint"))
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
    }
    
    private func testUserCreation() {
        guard let firebaseUser = Auth.auth().currentUser else {
            testMessage = "No Firebase user found. Please sign in first."
            return
        }
        
        isLoading = true
        testMessage = ""
        
        Task {
            do {
                try await authService.createUserProfile(
                    name: "Test User",
                    username: "testuser\(Int.random(in: 1000...9999))",
                    birthday: Date()
                )
                await MainActor.run {
                    testMessage = "User profile created successfully!"
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    testMessage = "Error: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    DatabaseTestView(authService: AuthenticationService())
} 