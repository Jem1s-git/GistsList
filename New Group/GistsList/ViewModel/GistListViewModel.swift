//
//  GistListViewModel.swift
//  GistsList
//
//  Created by Кирилл Уваров on 22.10.2024.
//

import Foundation
import Combine

class GistListViewModel {
    @Published private(set) var gists: [Gist] = []
    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()
    
    func fetchGists() {
        GitHubAPI.shared.fetchGists(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch gists:", error)
                }
            } receiveValue: { [weak self] newGists in
                self?.gists.append(contentsOf: newGists)
            }
            .store(in: &cancellables)
    }
    
    func refreshGists() {
        currentPage = 1
        gists.removeAll()
        fetchGists()
    }
    
    func loadMoreGists() {
        currentPage += 1
        fetchGists()
    }
}
