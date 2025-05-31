import SwiftUI

struct MainView: View {
    @ObservedObject var authService: AuthenticationService
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SongSearchView()
                .tabItem {
                    Label("Drop", systemImage: "music.note")
                }
                .tag(0)
            
            // Placeholder for Friends' Playlist
            VStack {
                Text("Friends' Playlist")
                    .font(.title)
                    .foregroundColor(Color("MintGreen"))
                    .padding()
                
                Text("Your friends' daily drops will appear here")
                    .foregroundColor(.secondary)
            }
            .tabItem {
                Label("Playlist", systemImage: "music.note.list")
            }
            .tag(1)
            
            // Profile/Settings
            VStack {
                if let user = authService.user {
                    Text("Signed in as: \(user.name ?? user.email ?? "User")")
                        .foregroundColor(.secondary)
                }
                
                Button("Sign Out") {
                    authService.signOut()
                }
                .foregroundColor(.red)
                .padding()
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle")
            }
            .tag(2)
        }
        .background(Color("OffWhite").ignoresSafeArea())
        .navigationTitle(Text("Synq").foregroundColor(Color("MintGreen")))
    }
}

#Preview {
    MainView(authService: AuthenticationService())
} 