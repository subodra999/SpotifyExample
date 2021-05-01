//
//  ViewController.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 30/04/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))
        fetchData()
    }
    
    @objc private func didTapSettings() {
        let vc = SettingsViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchData() {
        NetworkManager.shared.getRecommendedGenres { (result) in
            switch result {
            case .success(let model):
                if let genres = model.genres {
                    var seeds = Set<String>()
                    while seeds.count < 5 {
                        if let random = genres.randomElement() {
                            seeds.insert(random)
                        }
                    }
                    NetworkManager.shared.getRecommendations(genres: seeds){ result in
                        switch result {
                        case .success(let model):
                            print(model)
                        case .failure(_):
                            print("Error")
                        }
                    }
                }
            case .failure(_):
                print("error")
            }
        }
    }

}

