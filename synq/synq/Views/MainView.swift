import SwiftUI

struct MainView: View {
    @ObservedObject var authService: AuthenticationService
    @State private var selectedTab: Int
    @State private var showDropSongView = false

    init(authService: AuthenticationService) {
        self.authService = authService
        // Default to Playlist tab (index 0)
        _selectedTab = State(initialValue: 0)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Friends' Playlist (This is where the FeedView with tiles will go)
            FeedView() // Replace placeholder with FeedView
                .tabItem {
                    Label("Playlist", systemImage: "music.note.list")
                }
                .tag(0)

            // Profile/Settings
            NavigationView { // Wrap Profile in NavigationView for potential future navigation
                ZStack {
                    Color("OffWhite").ignoresSafeArea() // Set background to OffWhite
                    
                    ScrollView { // Allow scrolling if content exceeds screen height
                        VStack(spacing: 20) {
                            // Profile Picture Placeholder
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray) // Keep gray for now
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                .padding(.top, 20)
                            
                            // User Name
                            Text(authService.user?.displayName ?? "Synq User")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary) // Use primary color for dark text on light background
                            
                            // Add Bio and Location Buttons
                            HStack(spacing: 16) {
                                Button("+ Add bio") {
                                    // Action to add bio
                                }
                                .font(.callout)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray5)) // Lighter gray background
                                .foregroundColor(.primary) // Dark text
                                .cornerRadius(20)
                                
                                Button("+ Add location") {
                                    // Action to add location
                                }
                                .font(.callout)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray5)) // Lighter gray background
                                .foregroundColor(.primary) // Dark text
                                .cornerRadius(20)
                            }
                            
                            // Stats (Synqs and Friends)
                            HStack(spacing: 40) {
                                VStack {
                                    Text("20") // Mock Synq count
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary) // Dark text
                                    Text("Synqs")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                VStack {
                                    Text("49") // Mock Friends count
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary) // Dark text
                                    Text("Friends")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            // Share Profile Button
                            Button(action: {
                                // Action to share profile
                            }) {
                                Label("Share Profile", systemImage: "square.and.arrow.up")
                                    .font(.headline)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(Color("FreshMint").opacity(0.8)) // Green background
                                    .foregroundColor(.white) // White text on green background
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            
                            // Past Synqs Grid
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Your Synqs")
                                    .font(.headline)
                                    .foregroundColor(.primary) // Dark text
                                    .padding(.leading)
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 4) {
                                    ForEach(0..<10) { index in // Mock 10 items
                                        // Placeholder for a Synq preview tile
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(.systemGray5)) // Lighter gray fill
                                            .aspectRatio(1, contentMode: .fit)
                                            .overlay(
                                                Text("Synq \(index + 1)")
                                                    .foregroundColor(.gray) // Gray text
                                            )
                                    }
                                }
                                .padding(.horizontal, 2)
                            }
                            
                            // Sign Out Button
                            Button("Sign Out") {
                                authService.signOut()
                            }
                            .foregroundColor(.red)
                            .padding()
                        }
                        .padding(.bottom, 80) // Add padding at the bottom to account for the tab bar
                    }
                }
                .navigationTitle(Text("Profile").foregroundColor(.primary)) // Dark title
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { // Add toolbar for settings button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView(authService: authService)) {
                            Image(systemName: "gearshape")
                                .foregroundColor(.primary) // Dark icon
                        }
                    }
                }
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle")
            }
            .tag(1)
        }
        .background(Color("OffWhite").ignoresSafeArea()) // Keep OffWhite background behind the TabView
        .navigationTitle(Text("Synq").foregroundColor(Color("FreshMint"))) // Changed MintGreen to FreshMint
        .onReceive(NotificationCenter.default.publisher(for: .openDropSongView)) { _ in
            showDropSongView = true
        }
        .sheet(isPresented: $showDropSongView) {
            DropSongView()
        }
    }
}

#Preview {
    // Provide an AuthenticationService instance for the preview
    let authService = AuthenticationService()
    // Create a mock user profile for previewing the authenticated state
    let mockUser = UserProfile(id: "preview_id", displayName: "Preview User", onboardingComplete: true)
    authService.user = mockUser // Set the mock user
    authService.isAuthenticated = true // Set as authenticated
    return MainView(authService: authService)
} 