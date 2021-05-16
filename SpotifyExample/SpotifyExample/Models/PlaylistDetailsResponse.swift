//
//  PlaylistDetailsResponse.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 16/05/21.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
    let description: String?
    let external_urls: [String: String]?
    let id: String?
    let images: [APIImage]?
    let name: String?
    let tracks: TracksResponse
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]?
}

struct PlaylistItem: Codable {
    let track: AudioTrack?
}
