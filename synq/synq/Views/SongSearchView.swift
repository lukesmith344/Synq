import SwiftUI

struct SongSearchView: View {
    @StateObject private var searchService = SongSearchService()
    @State private var searchText = ""
    @State private var showingDropConfirmation = false
    @State private var selectedSong: Song?
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack {
                Picker("Music Service", selection: $searchService.selectedService) {
                    Text("Apple Music").tag(Song.MusicService.appleMusic)
                    Text("Spotify").tag(Song.MusicService.spotify)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            
            // Search Field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search songs...", text: $searchText)
                    .textFieldStyle(.plain)
                    .autocapitalization(.none)
                    .onChange(of: searchText) { newValue in
                        Task {
                            await searchService.searchSongs(query: newValue)
                        }
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        searchService.clearSearch()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Search Results
            if searchService.isSearching {
                ProgressView()
                    .padding()
            } else if searchService.searchResults.isEmpty && !searchText.isEmpty {
                ContentUnavailableView(
                    "No Results",
                    systemImage: "music.note",
                    description: Text("Try searching for a different song")
                )
            } else {
                List(searchService.searchResults) { song in
                    SongRow(song: song)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedSong = song
                            showingDropConfirmation = true
                        }
                }
                .listStyle(.plain)
            }
        }
        .alert("Drop Song", isPresented: $showingDropConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Drop") {
                // TODO: Implement song drop functionality
                // This will be implemented when we add the backend
            }
        } message: {
            if let song = selectedSong {
                Text("Are you sure you want to drop '\(song.title)' by \(song.artist)?")
            }
        }
    }
}

struct SongRow: View {
    let song: Song
    
    var body: some View {
        HStack(spacing: 12) {
            // Album Art
            if let albumArtURL = song.albumArtURL {
                AsyncImage(url: albumArtURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 50, height: 50)
                .cornerRadius(6)
            } else {
                Image(systemName: "music.note")
                    .font(.title)
                    .foregroundColor(.secondary)
                    .frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(6)
            }
            
            // Song Info
            VStack(alignment: .leading, spacing: 4) {
                Text(song.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(song.artist)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Service Icon
            Image(systemName: song.service == .appleMusic ? "apple.logo" : "music.note")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SongSearchView()
} 