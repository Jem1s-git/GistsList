//
//  NetworkManager.swift
//  GistsList
//
//  Created by Кирилл Уваров on 22.10.2024.
//

import Foundation

class GitHubAPI {
    static let shared = GitHubAPI()
    
    private let baseUrl = "https://api.github.com"
    
    func fetchGists(page: Int, completion: @escaping (Result<[Gist], Error>) -> Void) {
        let urlString = "\(baseUrl)/gists/public?page=\(page)&per_page=20"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let gists = try JSONDecoder().decode([Gist].self, from: data)
                completion(.success(gists))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchGistDetails(gistId: String, completion: @escaping (Result<GistDetail, Error>) -> Void) {
        let urlString = "\(baseUrl)/gists/\(gistId)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let gistDetail = try JSONDecoder().decode(GistDetail.self, from: data)
                completion(.success(gistDetail))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
