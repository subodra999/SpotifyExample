//
//  SettingsModels.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 01/05/21.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
