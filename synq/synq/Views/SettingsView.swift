import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var authService: AuthenticationService
    
    var body: some View {
        VStack {
            Spacer()
            Text("Settings")
                .font(.largeTitle)
                .padding()
            
            Button("Sign Out") {
                authService.signOut()
                presentationMode.wrappedValue.dismiss() // Dismiss settings view after signing out
            }
            .foregroundColor(.red)
            .padding()
            
            Spacer()
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("OffWhite").ignoresSafeArea())
    }
}

#Preview {
    // Provide an AuthenticationService instance for the preview
    let authService = AuthenticationService()
    return SettingsView(authService: authService)
} 