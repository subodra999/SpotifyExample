//
//  RecommendationsResponse.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 02/05/21.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]?
}
