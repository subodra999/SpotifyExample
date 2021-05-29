//
//  LibraryPlaylistsViewController.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 28/05/21.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        return tableView
    }()
    
    private let noPlaylistsView = ActionPlaceHolderView()
    private var playlists = [Playlist]()
    
    public var selectionHandler: ((Playlist) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if selectionHandler != nil {
            navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
  
        view.addSubview(noPlaylistsView)
        noPlaylistsView.delegate = self
        noPlaylistsView.configure(with: ActionPlaceHolderViewViewModel(infoText: "You don't have any playlists yet.", actionTitle: "create"))
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func fetchData() {
        NetworkManager.shared.getCurrentUserPlaylists { (result) in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI() {
        if playlists.isEmpty {
            noPlaylistsView.isHidden = false
            tableView.isHidden = true
        } else {
            noPlaylistsView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistsView.frame = CGRect(
            x: 0,
            y: 0,
            width: 150,
            height: 150
        )
        noPlaylistsView.center = view.center
        tableView.frame = view.bounds
    }
    
    public func showCreatePlaylistAlert() {
        let alert = UIAlertController(
            title: "New Playlists",
            message: "Enter Playlist name",
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "Playlist..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let textField = alert.textFields?.first,
                  let text = textField.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            NetworkManager.shared.createPlaylist(with: text) { [weak self] (result) in
                if result {
                    self?.fetchData()
                } else {
                    print("Playlist creation failed :(")
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }

}

extension LibraryPlaylistsViewController: ActionPlaceHolderViewDelegate {
    
    func actionPlaceHolderViewDidTapButton(_ actionView: ActionPlaceHolderView) {
        showCreatePlaylistAlert()
    }
    
}

extension LibraryPlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath
        ) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(
            with: SearchResultSubtitleTableViewCellModel(
                title: playlist.name,
                subtitle: playlist.owner?.display_name,
                imgURL: URL(string: playlist.images?.first?.url ?? "")
            )
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playlist = playlists[indexPath.row]
        
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true, completion: nil)
            return
        }
        
        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
