//
//  SearchResultsResponse.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 20/05/21.
//

import Foundation

struct SearchResultsResponse: Codable {
    let albums: SearchAlbumResponse?
    let tracks: SearchTrackResponse?
    let artists: SearchArtistResponse?
    let playlists: SearchPlaylistResponse?
}

struct SearchAlbumResponse: Codable {
    let items: [Album]?
}


struct SearchPlaylistResponse: Codable {
    let items: [Playlist]?
}


struct SearchTrackResponse: Codable {
    let items: [AudioTrack]?
}


struct SearchArtistResponse: Codable {
    let items: [Artist]?
}


