import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject private var authService = AuthenticationService()
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            VStack {
                Spacer()
                VStack(spacing: 20) {
                    // App Name
                    Text("Synq")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(Color("FreshMint"))
                        .kerning(2)
                        .padding(.bottom, 4)
                    // Tagline
                    Text("Share your music with friends")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                // Sign in with Apple Button
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
                .frame(maxWidth: 320)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                .padding(.top, 16)
                
                Spacer()
            }
            .padding(.horizontal, 40)
        }
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