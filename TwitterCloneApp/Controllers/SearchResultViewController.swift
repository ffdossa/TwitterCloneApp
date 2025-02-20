//
//  SearchResultViewController.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    var users: [UserModel] = []
    
    private let searchResultTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchUserTableViewCell.self, forCellReuseIdentifier: SearchUserTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResultTableView)
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        addConstraints()
    }
    
    func updateUsers(users: [UserModel]) {
        self.users = users
        DispatchQueue.main.async() { [weak self] in
            self?.searchResultTableView.reloadData()
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
        searchResultTableView.topAnchor.constraint(equalTo: view.topAnchor),
        searchResultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        searchResultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        searchResultTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchUserTableViewCell.identifier, for: indexPath) as? SearchUserTableViewCell
        else { return UITableViewCell() }
        let user = users[indexPath.row]
        cell.configureUsers(with: user)
        return cell
    }
}

extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        let profileViewModel = ProfileViewModel(user: user)
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        present(profileViewController, animated: true)
    }
}
