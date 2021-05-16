//
//  AlbumViewController.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 16/05/21.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let album: Album
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        NetworkManager.shared.getAlbumDetails(for: album) { (result) in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let error):
                break
            }
        }
    }

}
