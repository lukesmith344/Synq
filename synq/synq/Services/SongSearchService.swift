import Foundation
import SwiftUI

@MainActor
class SongSearchService: ObservableObject {
    @Published var searchResults: [Song] = []
    @Published var isSearching = false
    @Published var error: String?
    @Published var selectedService: Song.MusicService = .appleMusic
    
    // TODO: Implement actual API calls to Apple Music and Spotify
    // For now, we'll use mock data
    func searchSongs(query: String) async {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        error = nil
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Mock data for testing
        searchResults = [
            Song(
                id: "1",
                title: "Bohemian Rhapsody",
                artist: "Queen",
                albumArtURL: URL(string: "https://example.com/queen.jpg"),
                serviceURL: URL(string: "https://music.apple.com/us/album/bohemian-rhapsody"),
                service: selectedService,
                timestamp: Date()
            ),
            Song(
                id: "2",
                title: "Starman",
                artist: "David Bowie",
                albumArtURL: URL(string: "https://example.com/bowie.jpg"),
                serviceURL: URL(string: "https://music.apple.com/us/album/starman"),
                service: selectedService,
                timestamp: Date()
            ),
            Song(
                id: "3",
                title: "Purple Rain",
                artist: "Prince",
                albumArtURL: URL(string: "https://example.com/prince.jpg"),
                serviceURL: URL(string: "https://music.apple.com/us/album/purple-rain"),
                service: selectedService,
                timestamp: Date()
            )
        ].filter { song in
            song.title.localizedCaseInsensitiveContains(query) ||
            song.artist.localizedCaseInsensitiveContains(query)
        }
        
        isSearching = false
    }
    
    func clearSearch() {
        searchResults = []
        error = nil
    }
} 