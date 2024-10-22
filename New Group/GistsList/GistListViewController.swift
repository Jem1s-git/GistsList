//
//  GistListViewController.swift
//  GistsList
//
//  Created by Кирилл Уваров on 22.10.2024.
//

import UIKit

class GistListViewController: UIViewController {
    
    private var gists: [Gist] = []
    private var currentPage = 1
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchGists()
    }
    
    private func setupUI() {
        title = "Gists"
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GistCell.self, forCellReuseIdentifier: "GistCell")
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshGists), for: .valueChanged)
    }
    
    private func fetchGists() {
        GitHubAPI.shared.fetchGists(page: currentPage) { [weak self] result in
            switch result {
            case .success(let gists):
                DispatchQueue.main.async {
                    self?.gists.append(contentsOf: gists)
                    self?.tableView.reloadData()
                    self?.tableView.refreshControl?.endRefreshing()
                }
            case .failure(let error):
                print("Failed to fetch gists:", error)
            }
        }
    }
    
    @objc private func refreshGists() {
        currentPage = 1
        gists.removeAll()
        fetchGists()
    }
}

extension GistListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GistCell", for: indexPath) as! GistCell
        cell.configure(with: gists[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gist = gists[indexPath.row]
        let detailVC = GistDetailViewController(gistId: gist.id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
