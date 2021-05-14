//
//  FeaturedPlaylistsResponse.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 01/05/21.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistsResponse?
}

struct PlaylistsResponse: Codable {
    let items: [Playlist]?
}

struct User: Codable {
    let id: String?
    let display_name: String?
    let external_urls: [String: String]?
}
