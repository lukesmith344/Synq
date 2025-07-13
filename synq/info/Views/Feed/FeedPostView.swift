import SwiftUI

struct FeedPostView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Main post image (system image)
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color(.systemGray6))
                    .frame(width: 340, height: 440)
                    .shadow(radius: 10)
                Image(systemName: "music.note")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(Color(.systemGray3))
            }
            // Selfie/profile overlay (system image)
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
                    .frame(width: 90, height: 120)
                    .shadow(radius: 2)
                Image(systemName: "person.crop.square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color("FreshMint"))
            }
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white, lineWidth: 3))
            .offset(x: 16, y: 32)
            // Status row
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.pink)
                    .frame(width: 16, height: 16)
                Text("20 hr Late")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .frame(width: 340, height: 440)
        .padding(.vertical, 24)
    }
}

#Preview {
    FeedPostView()
} 