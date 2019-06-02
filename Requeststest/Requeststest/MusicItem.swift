import Foundation

struct MusicItems: Codable {
    let results: [MusicItem]!
    let resultCount: Double!
}

struct MusicItem: Codable {
    var artistId: Double!
    var collectionId: Double!
    var trackId: Double!
    var artistName: String!
    var collectionName: String!
    var trackName: String!
    var collectionPrice: Double!
    var previewUrl: String!
    var artworkUrl100: String!
}
