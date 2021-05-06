//
//  PlayList.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 30/04/21.
//

import Foundation

struct Playlist: Codable {
    let id: String?
    let name: String?
    let description: String?
    let external_urls: [String: String]?
    let images: [APIImage]?
    let type: String?
    let owner: User?
}
