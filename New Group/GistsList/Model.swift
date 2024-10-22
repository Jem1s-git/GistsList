//
//  Model.swift
//  GistsList
//
//  Created by Кирилл Уваров on 22.10.2024.
//

import Foundation


struct Gist: Codable {
    let id: String
    let description: String?
    let owner: Owner
}

struct GistDetail: Codable {
    let owner: Owner
    let description: String?
    let files: [String: GistFile]
    let commits: [Commit]?

    enum CodingKeys: String, CodingKey {
        case owner
        case description
        case files
        case commits
    }
}

struct Owner: Codable {
    let login: String
    let avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}

struct GistFile: Codable {
    let filename: String
    let content: String?
}

struct Commit: Codable {
    let version: String
    let committedAt: String?

    enum CodingKeys: String, CodingKey {
        case version
        case committedAt = "committed_at"
    }
}
