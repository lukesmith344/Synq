import SwiftUI

struct SplashView: View {
    @State private var navigate = false
    
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
            OnboardingNameView()
        }
    }
}

#Preview {
    SplashView()
} 