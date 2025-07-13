import SwiftUI

struct FeedView: View {
    @State private var selectedTab = 0 // 0 = My Friends, 1 = Discovery
    
    let mockCards: [SynqCardView] = [
        SynqCardView(
            profileImage: Image(systemName: "person.crop.circle.fill"),
            userName: "Taylor Swift",
            timestamp: "20 hr late",
            albumImage: nil,
            songTitle: "Cruel Summer",
            artist: "Taylor Swift",
            caption: "This song is a vibe!",
            sharedAgo: "shared 2 hours ago"
        ),
        SynqCardView(
            profileImage: Image(systemName: "person.crop.circle.fill"),
            userName: "Drake",
            timestamp: "On time",
            albumImage: nil,
            songTitle: "Hotline Bling",
            artist: "Drake",
            caption: nil,
            sharedAgo: "shared 1 hour ago"
        ),
        SynqCardView(
            profileImage: Image(systemName: "person.crop.circle.fill"),
            userName: "Phoebe Bridgers",
            timestamp: "5 min late",
            albumImage: nil,
            songTitle: "Motion Sickness",
            artist: "Phoebe Bridgers",
            caption: "Repeat all day.",
            sharedAgo: "shared 10 min ago"
        ),
        SynqCardView(
            profileImage: Image(systemName: "person.crop.circle.fill"),
            userName: "SZA",
            timestamp: "On time",
            albumImage: nil,
            songTitle: "Good Days",
            artist: "SZA",
            caption: nil,
            sharedAgo: "shared just now"
        )
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            // Feed content (vertical scroll)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(0..<mockCards.count, id: \.self) { i in
                        mockCards[i]
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 0)
                            .padding(.bottom, 6)
                    }
                    // End of feed message
                    VStack {
                        Text("Looks like you reached the end. Maybe go outside or something")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 16)
                            .padding(.bottom, 12)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.top, 100)
                .padding(.bottom, 20)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            // Top bar and tabs with frosted, more white background
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "person.2.fill")
                        .font(.title2)
                        .foregroundColor(.black)
                    Spacer()
                    Text("Synq")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black)
                        .kerning(1.2)
                    Spacer()
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44) // Respect safe area
                // Inline tab selectors
                HStack(spacing: 32) {
                    Button(action: { selectedTab = 0 }) {
                        VStack(spacing: 4) {
                            Text("My Friends")
                                .fontWeight(.semibold)
                                .foregroundColor(selectedTab == 0 ? Color("FreshMint") : Color(.systemGray))
                            Capsule()
                                .fill(selectedTab == 0 ? Color("FreshMint") : Color.clear)
                                .frame(height: 3)
                                .frame(maxWidth: 36)
                        }
                    }
                    Button(action: { selectedTab = 1 }) {
                        VStack(spacing: 4) {
                            Text("Discovery")
                                .fontWeight(.semibold)
                                .foregroundColor(selectedTab == 1 ? Color("FreshMint") : Color(.systemGray))
                            Capsule()
                                .fill(selectedTab == 1 ? Color("FreshMint") : Color.clear)
                                .frame(height: 3)
                                .frame(maxWidth: 36)
                        }
                    }
                }
                .padding(.top, 4)
                Divider().background(Color.black.opacity(0.08))
            }
            .background(
                ZStack {
                    Color.white.opacity(0.85)
                    .blur(radius: 0.5)
                    .background(.ultraThinMaterial)
                }
            )
            .ignoresSafeArea(.container, edges: .top)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

#Preview {
    FeedView()
} 