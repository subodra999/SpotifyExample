//
//  SettingsViewController.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 30/04/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tb
    }()
    
    private var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSections()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureSections() {
        sections.append(Section(title: "Profile", options: [Option(title: "my profile", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.myProfileTapped()
            }
        })]))
        sections.append(Section(title: "Account", options: [Option(title: "sign out", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.signOutTapped()
            }
        })]))
    }
    
    private func myProfileTapped() {
        let vc = ProfileViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Profile"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signOutTapped() {
        
    }

}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = sections[indexPath.section].options[indexPath.row]
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    
}
