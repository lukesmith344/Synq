import SwiftUI

struct OnboardingContainerView: View {
    @StateObject var viewModel: OnboardingViewModel

    var body: some View {
        switch viewModel.onboardingStep {
        case 1:
            OnboardingNameView(viewModel: viewModel)
        case 2:
            OnboardingBirthdayView(viewModel: viewModel)
        case 3:
            OnboardingUsernameView(viewModel: viewModel)
        case 4:
            OnboardingContactsView(viewModel: viewModel)
        default:
            // Onboarding complete, show main app or a completion screen
            MainView(authService: viewModel.authService)
        }
    }
}

#Preview {
    OnboardingContainerView(viewModel: OnboardingViewModel(authService: AuthenticationService()))
} 