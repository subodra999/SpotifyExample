//
//  PlaybackPresenter.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 23/05/21.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    private var index: Int = 0
    private var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if !tracks.isEmpty && index < tracks.count {
            return tracks[index]
        }
        return nil
    }
    
    private var player: AVPlayer?
    private var playerQueue: AVQueuePlayer?
    private var playerVC: PlayerViewController?
    
    func startPlayback(from viewController: UIViewController, track: AudioTrack) {
        
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        self.player = AVPlayer(url: url)
        self.player?.volume = 0.5
        
        self.track = track
        self.tracks = []
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = vc
    }
    
    func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]) {
        
        self.track = nil
        self.tracks = tracks
        self.index = 0
        
        let items: [AVPlayerItem] = tracks.compactMap( {
            guard let url = URL(string: $0.preview_url ?? "" ) else { return nil }
            return AVPlayerItem(url: url)
        })
        self.playerQueue = AVQueuePlayer(items: items)
        self.playerQueue?.volume = 0.5
        self.playerQueue?.play()
        
        let vc = PlayerViewController()
        vc.delegate = self
        vc.dataSource = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true)
        self.playerVC = vc
    }
    
}

extension PlaybackPresenter: PlayerDataSource {
    
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists?.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images?.first?.url ?? "")
    }

}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        } else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
        } else {
            if let player = playerQueue {
                index = (index + 1) % tracks.count
                player.advanceToNextItem()
                playerVC?.refreshUI()
            }
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
            player?.play()
        } else {
            if let firstItem = playerQueue?.items().first {
                index = 0
                playerQueue?.pause()
                playerQueue?.removeAllItems()
                playerQueue = nil
                playerQueue = AVQueuePlayer(items: [firstItem])
                playerQueue?.play()
                playerQueue?.volume = 0.5
                playerVC?.refreshUI()
            }
        }
    }
    
}
