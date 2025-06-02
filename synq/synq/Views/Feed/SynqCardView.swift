import SwiftUI

struct SynqCardView: View {
    let profileImage: Image
    let userName: String
    let timestamp: String
    let albumImage: Image?
    let songTitle: String
    let artist: String
    let caption: String?
    let sharedAgo: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 10) {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 2) {
                    Text(userName)
                        .font(.system(size: 17, weight: .semibold))
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                        Text(timestamp)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(Color(.systemGray5))
                    .clipShape(Capsule())
                }
                Spacer()
            }
            .padding(.bottom, 10)
            if let albumImage = albumImage {
                albumImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 170)
                    .cornerRadius(14)
                    .shadow(radius: 2)
                    .frame(maxWidth: .infinity)
            } else {
                Text("🎵")
                    .font(.system(size: 90))
                    .frame(height: 170)
                    .frame(maxWidth: .infinity)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(songTitle)
                    .font(.system(size: 22, weight: .bold))
                Text(artist)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 6)
            if let caption = caption {
                Text(caption)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .padding(.top, 3)
            }
            Spacer(minLength: 0)
            if let sharedAgo = sharedAgo {
                Text(sharedAgo)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .padding(.top, 6)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 18)
        .frame(height: UIScreen.main.bounds.height * 0.75)
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.965, green: 0.965, blue: 0.965))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.09), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    SynqCardView(
        profileImage: Image(systemName: "person.crop.circle.fill"),
        userName: "Taylor Swift",
        timestamp: "20 hr late",
        albumImage: nil,
        songTitle: "Cruel Summer",
        artist: "Taylor Swift",
        caption: "This song is a vibe!",
        sharedAgo: "shared 2 hours ago"
    )
} 