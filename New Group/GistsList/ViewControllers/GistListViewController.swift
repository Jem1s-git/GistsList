//
//  GistListViewController.swift
//  GistsList
//
//  Created by Кирилл Уваров on 22.10.2024.
//

import UIKit
import Combine

class GistListViewController: UIViewController {
    
    private let viewModel = GistListViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let tableView = UITableView()
    
    // Добавляем флаг для контроля обновления
    private var needsTableUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchGists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Проверяем флаг и обновляем таблицу только если это необходимо
        if needsTableUpdate {
            tableView.reloadData()
            needsTableUpdate = false
        }
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
    
    private func bindViewModel() {
        viewModel.$gists
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // Вместо немедленного обновления, устанавливаем флаг
                self?.needsTableUpdate = true
                // Если представление видимо, обновляем таблицу сразу
                if self?.isViewLoaded == true && (self?.view.window != nil) {
                    self?.tableView.reloadData()
                    self?.needsTableUpdate = false
                }
                self?.tableView.refreshControl?.endRefreshing()
            }
            .store(in: &cancellables)
    }
    
    @objc private func refreshGists() {
        viewModel.refreshGists()
    }
}


extension GistListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.gists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GistCell", for: indexPath) as! GistCell
        cell.configure(with: viewModel.gists[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gist = viewModel.gists[indexPath.row]
        let detailVC = GistDetailViewController(gistId: gist.id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.gists.count - 1 {
            viewModel.loadMoreGists()
        }
    }
}
