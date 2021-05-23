//
//  SearchResultViewController.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 30/04/21.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

protocol SearchResultViewControllerDelegate: class {
    func didTapResult(_ result: SearchResult)
}

class SearchResultViewController: UIViewController {

    weak var delegate: SearchResultViewControllerDelegate?
    
    private var sections: [SearchSection] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    public func update(with results: [SearchResult]) {
        let albums = results.filter { (res) -> Bool in
            switch res {
            case .album(_):
                return true
            default:
                return false
            }
        }
        let playlists = results.filter { (res) -> Bool in
            switch res {
            case .playlist(_):
                return true
            default:
                return false
            }
        }
        let tracks = results.filter { (res) -> Bool in
            switch res {
            case .track(_):
                return true
            default:
                return false
            }
        }
        let artists = results.filter { (res) -> Bool in
            switch res {
            case .artist(_):
                return true
            default:
                return false
            }
        }
        
        sections.append(SearchSection(title: "Albums", results: albums))
        sections.append(SearchSection(title: "Playlists", results: playlists))
        sections.append(SearchSection(title: "Tracks", results: tracks))
        sections.append(SearchSection(title: "Artists", results: artists))
        
        tableView.reloadData()
        tableView.isHidden = sections.isEmpty
    }

}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
        case .album(let album):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                    for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(
                with: SearchResultSubtitleTableViewCellModel(
                    title: album.name,
                    subtitle: album.artists?.first?.name,
                    imgURL: URL(string: album.images?.first?.url ?? "")
                )
            )
            return cell
        case .artist(let artist):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchResultDefaultTableViewCell.identifier,
                    for: indexPath
            ) as? SearchResultDefaultTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(
                with: SearchResultDefaultTableViewCellModel(
                    title: artist.name,
                    imgURL: URL(string: artist.images?.first?.url ?? "")
                )
            )
            return cell
        case .track(let track):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                    for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(
                with: SearchResultSubtitleTableViewCellModel(
                    title: track.name,
                    subtitle: track.artists?.first?.name,
                    imgURL: URL(string: track.album?.images?.first?.url ?? "")
                )
            )
            return cell
        case .playlist(let playlist):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                    for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(
                with: SearchResultSubtitleTableViewCellModel(
                    title: playlist.name,
                    subtitle: playlist.owner?.display_name,
                    imgURL: URL(string: playlist.images?.first?.url ?? "")
                )
            )
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
    }
    
    
}
