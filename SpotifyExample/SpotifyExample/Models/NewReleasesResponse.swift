//
//  NewReleasesResponse.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 01/05/21.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse?
}

struct AlbumsResponse: Codable {
    let items: [Album]?
}
