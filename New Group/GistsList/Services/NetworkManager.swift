//
//  NetworkManager.swift
//  GistsList
//
//  Created by Кирилл Уваров on 22.10.2024.
//

import Foundation
import Combine

class GitHubAPI {
    static let shared = GitHubAPI()
    private init() {}
    
    private let baseUrl = "https://api.github.com"
    
    func fetchGists(page: Int) -> AnyPublisher<[Gist], Error> {
        let urlString = "\(baseUrl)/gists/public?page=\(page)&per_page=20"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Gist].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchGistDetails(gistId: String) -> AnyPublisher<GistDetail, Error> {
        let urlString = "\(baseUrl)/gists/\(gistId)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GistDetail.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
