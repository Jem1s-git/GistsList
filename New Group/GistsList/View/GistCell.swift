//
//  GistCell.swift
//  GistsList
//
//  Created by Кирилл Уваров on 22.10.2024.
//

import UIKit

class GistCell: UITableViewCell {
    
    private let avatarImageView = UIImageView()
    private let authorLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Настройка аватара
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        contentView.addSubview(avatarImageView)
        
        // Настройка имени автора
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(authorLabel)
        
        // Настройка описания гиста
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray
        contentView.addSubview(descriptionLabel)
        
        // Настройка AutoLayout для элементов
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            authorLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // Метод для настройки ячейки с данными о гисте
    func configure(with gist: Gist) {
        authorLabel.text = gist.owner.login
        descriptionLabel.text = gist.description ?? "No description"
        
        // Асинхронная загрузка аватара с кэшированием
        if let url = URL(string: gist.owner.avatarUrl) {
            loadImage(from: url)
        }
    }
    
    // Метод для загрузки изображения с кэшированием
    private func loadImage(from url: URL) {
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        // Проверяем кэш
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.avatarImageView.image = image
        } else {
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let data = data, let response = response, let image = UIImage(data: data) else {
                    return
                }
                // Кэшируем изображение
                let cachedData = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedData, for: request)
                
                DispatchQueue.main.async {
                    self?.avatarImageView.image = image
                }
            }.resume()
        }
    }
}
