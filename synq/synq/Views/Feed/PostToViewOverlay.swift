import SwiftUI

struct PostToViewOverlay: View {
    var albumImage: Image? = nil
    var body: some View {
        ZStack {
            // Blurred, darkened album art background
            (albumImage ?? Image(systemName: "music.note"))
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .blur(radius: 18)
                .overlay(Color.black.opacity(0.55))
                .ignoresSafeArea()
            // Centered overlay
            VStack(spacing: 24) {
                Image(systemName: "eye.slash")
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundColor(.white)
                Text("Post to view")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                Text("To view your friends' Synqs, drop your song.")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                Button(action: {}) {
                    Text("Drop your Synq")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 36)
                        .background(Color("FreshMint"))
                        .cornerRadius(14)
                        .shadow(color: Color("FreshMint").opacity(0.18), radius: 8, x: 0, y: 4)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    PostToViewOverlay()
} 