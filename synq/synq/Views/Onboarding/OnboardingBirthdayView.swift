import SwiftUI

struct OnboardingBirthdayView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var navigate = false
    
    var body: some View {
        VStack {
            // Progress Indicator
            OnboardingProgressView(currentStep: 2, totalSteps: 4)
                .padding(.top, 32)
            Spacer()
            VStack(spacing: 24) {
                Text("When's your birthday?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                DatePicker("Birthday", selection: $viewModel.birthday, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
            }
            Spacer()
            Button(action: { navigate = true }) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("FreshMint"))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 32)
            NavigationLink(destination: OnboardingUsernameView(viewModel: viewModel), isActive: $navigate) { EmptyView() }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OnboardingBirthdayView(viewModel: OnboardingViewModel())
} 