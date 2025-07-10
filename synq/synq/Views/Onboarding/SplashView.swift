import SwiftUI

struct SplashView: View {
    let authService: AuthenticationService
    @State private var navigate = false
    
    init(authService: AuthenticationService) {
        self.authService = authService
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Text("Synq")
                .font(.system(size: 44, weight: .bold))
                .foregroundColor(Color("FreshMint"))
                .kerning(2)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                navigate = true
            }
        }
        .navigationDestination(isPresented: $navigate) {
            OnboardingNameView(authService: authService)
        }
    }
}

#Preview {
    SplashView(authService: AuthenticationService())
} 