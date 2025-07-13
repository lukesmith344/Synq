import SwiftUI

struct DropSongView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Drop your song of the day!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Text("Pick a song to share with your friends.")
                .font(.title3)
                .foregroundColor(.gray)
            // Add your song selection UI here
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DropSongView()
} 