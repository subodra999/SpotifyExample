//
//  LibraryAlbumsResponse.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 30/05/21.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]?
}

struct SavedAlbum: Codable {
    let added_at: String?
    let album: Album?
}
