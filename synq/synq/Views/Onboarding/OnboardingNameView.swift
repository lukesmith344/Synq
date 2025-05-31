import SwiftUI

struct OnboardingNameView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var navigate = false
    
    var body: some View {
        VStack {
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

#Preview {
    OnboardingNameView()
} 