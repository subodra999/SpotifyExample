//
//  Album.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 02/05/21.
//

import Foundation

struct Album: Codable {
    let id: String?
    let name: String?
    let album_type: String?
    let artists: [Artist]?
    let available_markets: [String]?
    let images: [APIImage]?
    let type: String?
    let release_date: String?
    let total_tracks: Int?
}
