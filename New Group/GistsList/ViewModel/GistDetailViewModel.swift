//
//  GistDetailViewModel.swift
//  GistsList
//
//  Created by Кирилл Уваров on 22.10.2024.
//
import Foundation
import Combine

class GistDetailViewModel {
    @Published private(set) var gistDetail: GistDetail?
    private var cancellables = Set<AnyCancellable>()
    private let gistId: String
    
    init(gistId: String) {
        self.gistId = gistId
    }
    
    func fetchGistDetail() {
        GitHubAPI.shared.fetchGistDetails(gistId: gistId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch gist detail:", error)
                }
            } receiveValue: { [weak self] gistDetail in
                self?.gistDetail = gistDetail
            }
            .store(in: &cancellables)
    }
    
    var numberOfFiles: Int {
        return gistDetail?.files.count ?? 0
    }
    
    func file(at index: Int) -> GistFile? {
        guard let files = gistDetail?.files else { return nil }
        let filesArray = Array(files.values)
        return index < filesArray.count ? filesArray[index] : nil
    }
}
