//
//  PlaylistViewController.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 16/05/21.
//

import UIKit

class PlaylistViewController: UIViewController {
 
    private let playlist: Playlist
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        NetworkManager.shared.getPlaylistDetails(for: playlist) { (result) in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let error):
                break
            }
        }
    }
    
}
