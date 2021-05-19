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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
        case .album(let model):
            cell.textLabel?.text = model.name
        case .artist(let model):
            cell.textLabel?.text = model.name
        case .track(let model):
            cell.textLabel?.text = model.name
        case .playlist(let model):
            cell.textLabel?.text = model.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
    }
    
    
}
