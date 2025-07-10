import SwiftUI

struct OnboardingNameView: View {
    let authService: AuthenticationService
    @StateObject private var viewModel: OnboardingViewModel
    @State private var navigate = false
    
    init(authService: AuthenticationService) {
        self.authService = authService
        self._viewModel = StateObject(wrappedValue: OnboardingViewModel(authService: authService))
    }
    
    var body: some View {
        VStack {
            // Progress Indicator
            OnboardingProgressView(currentStep: 1, totalSteps: 4)
                .padding(.top, 32)
            Spacer()
            VStack(spacing: 24) {
                Text("What's your name?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                TextField("Your name", text: $viewModel.name)
                    .font(.system(size: 28, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 16)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
            }
            Spacer()
            Button(action: { navigate = true }) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.name.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color("FreshMint"))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 32)
            .disabled(viewModel.name.trimmingCharacters(in: .whitespaces).isEmpty)
            NavigationLink(destination: OnboardingBirthdayView(viewModel: viewModel), isActive: $navigate) { EmptyView() }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct OnboardingProgressView: View {
    let currentStep: Int
    let totalSteps: Int
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...totalSteps, id: \.self) { step in
                Circle()
                    .fill(step <= currentStep ? Color("FreshMint") : Color(.systemGray4))
                    .frame(width: 10, height: 10)
            }
        }
    }
}

#Preview {
    OnboardingNameView(authService: AuthenticationService())
} 