//
//  Artist.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 30/04/21.
//

import Foundation

struct Artist: Codable {
    let id: String?
    let name: String?
    let type: String?
    let external_urls: [String: String]?
}
