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
            // Feed content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Color.clear.frame(height: 120) // Spacer for top bar
                    ForEach(0..<mockCards.count, id: \.self) { i in
                        GeometryReader { geo in
                            let minY = geo.frame(in: .global).minY
                            let screenHeight = UIScreen.main.bounds.height
                            let scale = max(0.95, min(1.0, 1.1 - abs(minY - 120) / screenHeight))
                            mockCards[i]
                                .scaleEffect(scale)
                                .animation(.easeOut(duration: 0.25), value: scale)
                        }
                        .frame(height: UIScreen.main.bounds.height * 0.65)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 0)
                    }
                }
                .padding(.top, 0)
                .padding(.bottom, 80) // Leave room for tab bar/action button
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            // Top bar and tabs with frosted glass
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("Synq")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color("FreshMint"))
                    Spacer()
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .padding(.top, 16)
                // Pill-style Segmented Control
                HStack(spacing: 0) {
                    Button(action: { selectedTab = 0 }) {
                        Text("My Friends")
                            .fontWeight(.semibold)
                            .foregroundColor(selectedTab == 0 ? .white : .primary)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(selectedTab == 0 ? Color("FreshMint") : Color.clear)
                            .clipShape(Capsule())
                            .shadow(color: selectedTab == 0 ? Color("FreshMint").opacity(0.25) : .clear, radius: 6, x: 0, y: 2)
                    }
                    Button(action: { selectedTab = 1 }) {
                        Text("Discovery")
                            .fontWeight(.semibold)
                            .foregroundColor(selectedTab == 1 ? .white : .primary)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(selectedTab == 1 ? Color("FreshMint") : Color.clear)
                            .clipShape(Capsule())
                            .shadow(color: selectedTab == 1 ? Color("FreshMint").opacity(0.25) : .clear, radius: 6, x: 0, y: 2)
                    }
                }
                .background(Color(.systemGray5).opacity(0.7))
                .clipShape(Capsule())
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                Divider()
            }
            .background(.ultraThinMaterial)
            .ignoresSafeArea(.container, edges: .top)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

#Preview {
    FeedView()
} 