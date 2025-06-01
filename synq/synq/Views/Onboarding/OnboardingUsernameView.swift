import SwiftUI

struct OnboardingUsernameView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var navigate = false
    
    var usernameError: String? {
        if viewModel.username.trimmingCharacters(in: .whitespaces).isEmpty {
            return nil
        }
        if viewModel.username.count < 3 {
            return "Username must be at least 3 characters."
        }
        if viewModel.username.contains(" ") {
            return "Username cannot contain spaces."
        }
        if let available = viewModel.usernameAvailable, !available {
            return "Username is not available."
        }
        return nil
    }
    
    var body: some View {
        VStack {
            // Progress Indicator
            OnboardingProgressView(currentStep: 3, totalSteps: 4)
                .padding(.top, 32)
            Spacer()
            VStack(spacing: 20) {
                Text("Choose your username")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                TextField("@username", text: $viewModel.username)
                    .font(.system(size: 28, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 16)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    .onChange(of: viewModel.username) { _ in
                        viewModel.checkUsernameAvailability()
                    }
                if let error = usernameError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.top, 2)
                } else if let available = viewModel.usernameAvailable, available {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Available")
                            .foregroundColor(.green)
                            .font(.subheadline)
                    }
                } else {
                    Text("3+ characters, no spaces")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }
            Spacer()
            Button(action: { navigate = true }) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((usernameError == nil && (viewModel.usernameAvailable ?? false)) ? Color("FreshMint") : Color.gray)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 32)
            .disabled(usernameError != nil || !(viewModel.usernameAvailable ?? false))
            NavigationLink(destination: OnboardingContactsView(viewModel: viewModel), isActive: $navigate) { EmptyView() }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OnboardingUsernameView(viewModel: OnboardingViewModel())
} 