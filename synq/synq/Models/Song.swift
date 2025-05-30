import Foundation

struct Song: Identifiable, Codable {
    let id: String
    let title: String
    let artist: String
    let albumArtURL: URL?
    let serviceURL: URL?
    let service: MusicService
    let timestamp: Date
    
    enum MusicService: String, Codable {
        case appleMusic = "Apple Music"
        case spotify = "Spotify"
    }
    
    // For preview and testing
    static let preview = Song(
        id: "preview-1",
        title: "Bohemian Rhapsody",
        artist: "Queen",
        albumArtURL: URL(string: "https://example.com/album-art.jpg"),
        serviceURL: URL(string: "https://music.apple.com/us/album/bohemian-rhapsody/1440806040?i=1440806041"),
        service: .appleMusic,
        timestamp: Date()
    )
} 