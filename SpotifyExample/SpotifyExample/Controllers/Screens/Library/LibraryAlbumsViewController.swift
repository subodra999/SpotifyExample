//
//  LibraryAlbumsViewController.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 28/05/21.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        return tableView
    }()
    
    private let noAlbumsView = ActionPlaceHolderView()
    private var albums = [Album]()
    private var observer: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
  
        view.addSubview(noAlbumsView)
        noAlbumsView.delegate = self
        noAlbumsView.configure(with: ActionPlaceHolderViewViewModel(infoText: "You have not saved any album yet.", actionTitle: "Browse"))
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotificaton,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.fetchData()
            }
        )
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func fetchData() {
        albums.removeAll()
        NetworkManager.shared.getCurrentUserAlbums { (result) in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI() {
        if albums.isEmpty {
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        } else {
            noAlbumsView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(
            x: (view.width - 150) / 2,
            y: (view.height - 150) / 2,
            width: 150,
            height: 150
        )
        tableView.frame = view.bounds
    }
}

extension LibraryAlbumsViewController: ActionPlaceHolderViewDelegate {
    
    func actionPlaceHolderViewDidTapButton(_ actionView: ActionPlaceHolderView) {
        tabBarController?.selectedIndex = 0 // back to browse tab
    }
    
}

extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath
        ) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let album = albums[indexPath.row]
        cell.configure(
            with: SearchResultSubtitleTableViewCellModel(
                title: album.name,
                subtitle: album.artists?.first?.name,
                imgURL: URL(string: album.images?.first?.url ?? "")
            )
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let album = albums[indexPath.row]
        
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
