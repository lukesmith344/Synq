import SwiftUI

struct OnboardingUsernameView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var navigate = false
    
    var body: some View {
        VStack {
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
                HStack(spacing: 8) {
                    if let available = viewModel.usernameAvailable {
                        Image(systemName: available ? "checkmark.circle.fill" : "xmark.octagon.fill")
                            .foregroundColor(available ? .green : .red)
                        Text(available ? "Available" : "Not available")
                            .foregroundColor(available ? .green : .red)
                            .font(.subheadline)
                    } else {
                        Text("3+ characters, no spaces")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
            }
            Spacer()
            Button(action: { navigate = true }) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((viewModel.usernameAvailable ?? false) ? Color("FreshMint") : Color.gray)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 32)
            .disabled(!(viewModel.usernameAvailable ?? false))
            NavigationLink(destination: OnboardingContactsView(viewModel: viewModel), isActive: $navigate) { EmptyView() }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OnboardingUsernameView(viewModel: OnboardingViewModel())
} 