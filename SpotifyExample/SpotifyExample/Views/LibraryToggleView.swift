//
//  LibraryToggleView.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 28/05/21.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView)
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    enum State {
        case playlist
        case album
    }
    
    private var playlistsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Playlists", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private var albumsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Albums", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    weak var delegate: LibraryToggleViewDelegate?
    var currentState: State = .playlist

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistsButton)
        addSubview(albumsButton)
        addSubview(indicatorView)
        
        playlistsButton.addTarget(self, action: #selector(didTapOnPlaylists), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapOnAlbums), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func didTapOnPlaylists() {
        delegate?.libraryToggleViewDidTapPlaylists(self)
    }
    
    @objc private func didTapOnAlbums() {
        delegate?.libraryToggleViewDidTapAlbums(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistsButton.frame = CGRect(
            x: 0,
            y: 0,
            width: 100,
            height: 40
        )
        albumsButton.frame = CGRect(
            x: playlistsButton.right,
            y: 0,
            width: 100,
            height: 40
        )
        layoutIndicator()
    }
    
    private func layoutIndicator() {
        switch currentState {
        case .playlist:
            indicatorView.frame = CGRect(
                x: 0,
                y: playlistsButton.bottom,
                width: 100,
                height: 3
            )
        case .album:
            indicatorView.frame = CGRect(
                x: 100,
                y: playlistsButton.bottom,
                width: 100,
                height: 3
            )
        }
    }
    
    func updateState(for state: State) {
        currentState = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }

}
