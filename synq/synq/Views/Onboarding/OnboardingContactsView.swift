import SwiftUI

struct OnboardingContactsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var finished = false
    
    var body: some View {
        VStack {
            // Progress Indicator
            OnboardingProgressView(currentStep: 4, totalSteps: 4)
                .padding(.top, 32)
            Spacer()
            VStack(spacing: 20) {
                Text("Find your friends on Synq")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                if !viewModel.contactsSynced {
                    Button(action: { viewModel.syncContacts() }) {
                        HStack {
                            Image(systemName: "person.2.fill")
                            Text("Sync Contacts")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("FreshMint"))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                } else {
                    VStack(spacing: 8) {
                        Text("Matched Friends:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        ForEach(viewModel.matchedContacts, id: \.self) { contact in
                            HStack {
                                Image(systemName: "person.crop.circle")
                                    .foregroundColor(Color("FreshMint"))
                                Text(contact)
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            Spacer()
            Button(action: { finished = true }) {
                Text("Finish")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("FreshMint"))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 32)
            .disabled(!viewModel.contactsSynced)
            // NavigationLink to main app or dismiss onboarding can go here
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OnboardingContactsView(viewModel: OnboardingViewModel())
} 