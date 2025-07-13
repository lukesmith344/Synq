import SwiftUI

struct OnboardingContactsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @StateObject private var contactsManager = ContactsManager()
    @State private var finished = false
    @State private var skipped = false
    @State private var isLoading = false
    @State private var error: Error?
    
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
                
                if let error = error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            Spacer()
            // Skip Button
            Button(action: {
                skipped = true
                Task {
                    await completeOnboarding()
                }
            }) {
                Text("Skip")
                    .font(.subheadline)
                    .foregroundColor(Color("FreshMint"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .padding(.horizontal, 40)
            .disabled(isLoading)
            // Finish Button
            Button(action: { 
                Task {
                    await completeOnboarding()
                }
            }) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    Text("Finish")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("FreshMint"))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 32)
            .disabled(!canFinish || isLoading)
            // NavigationLink to main app
            NavigationLink(destination: MainView(authService: viewModel.authService), isActive: $finished) { EmptyView() }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func completeOnboarding() async {
        isLoading = true
        error = nil
        
        do {
            try await viewModel.completeOnboarding()
            finished = true
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}

#Preview {
    OnboardingContactsView(viewModel: OnboardingViewModel(authService: AuthenticationService()))
} 