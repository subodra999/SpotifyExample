//
//  UserProfile.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 30/04/21.
//

import Foundation

struct UserProfile: Codable {
    let country: String?
    let display_name: String?
    let email: String?
    let external_urls: [String: String]?
    let id: String?
    let product: String?
    let images: [UserImage]?
}

struct UserImage: Codable {
    let url: String?
}
