//
//  SearchResult.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 20/05/21.
//

import Foundation

enum SearchResult {
    case album(model: Album)
    case playlist(model: Playlist)
    case track(model: AudioTrack)
    case artist(model: Artist)
}
