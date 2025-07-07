import SwiftUI

struct OnboardingContactsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @StateObject private var contactsManager = ContactsManager()
    @State private var finished = false
    @State private var skipped = false
    
    var canFinish: Bool {
        skipped || !contactsManager.matchedContacts.isEmpty || contactsManager.permissionDenied
    }
    
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
                if contactsManager.matchedContacts.isEmpty && !contactsManager.permissionDenied && !skipped {
                    Button(action: { contactsManager.requestAndFetchContacts() }) {
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
                } else if contactsManager.permissionDenied && !skipped {
                    Text("Permission denied. Please enable Contacts access in Settings.")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if !skipped {
                    VStack(spacing: 8) {
                        Text("Matched Friends:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        ForEach(contactsManager.matchedContacts, id: \.self) { contact in
                            HStack {
                                Image(systemName: "person.crop.circle")
                                    .foregroundColor(Color("FreshMint"))
                                Text(contact)
                                    .font(.headline)
                            }
                        }
                    }
                } else {
                    Text("You chose to skip syncing contacts.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            Spacer()
            // Skip Button
            Button(action: {
                skipped = true
                viewModel.completeOnboarding()
                finished = true
            }) {
                Text("Skip")
                    .font(.subheadline)
                    .foregroundColor(Color("FreshMint"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .padding(.horizontal, 40)
            // Finish Button
            Button(action: { 
                viewModel.completeOnboarding()
                finished = true 
            }) {
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
            .disabled(!canFinish)
            // NavigationLink to main app
            NavigationLink(destination: MainView(authService: AuthenticationService()), isActive: $finished) { EmptyView() }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OnboardingContactsView(viewModel: OnboardingViewModel())
} 