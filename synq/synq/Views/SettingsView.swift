import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var authService: AuthenticationService
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        Form {
            Section(header: Text("Account")) {
                Button("Sign Out") {
                    Task {
                        do {
                            try await authService.signOut()
                            presentationMode.wrappedValue.dismiss() // Dismiss settings view after signing out
                        } catch {
                            showError = true
                            errorMessage = error.localizedDescription
                        }
                    }
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("OffWhite").ignoresSafeArea())
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    // Provide an AuthenticationService instance for the preview
    let authService = AuthenticationService()
    return SettingsView(authService: authService)
} 