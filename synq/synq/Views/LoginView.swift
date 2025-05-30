import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject private var authService = AuthenticationService()
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Synq")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.primary)
            
            Text("Share your music with friends")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Spacer()
            
            SignInWithAppleButton(
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    Task {
                        do {
                            try await authService.signInWithApple()
                        } catch {
                            showError = true
                            errorMessage = error.localizedDescription
                        }
                    }
                }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    LoginView()
} 