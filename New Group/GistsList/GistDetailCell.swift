//
//  GistDetailCell.swift
//  GistsList
//
//  Created by Кирилл Уваров on 22.10.2024.
//

import UIKit

class GistDetailCell: UICollectionViewCell {
    
    private let fileNameLabel = UILabel()
    private let fileContentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Настройка имени файла
        fileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fileNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        fileNameLabel.numberOfLines = 0
        contentView.addSubview(fileNameLabel)
        
        // Настройка содержания файла
        fileContentLabel.translatesAutoresizingMaskIntoConstraints = false
        fileContentLabel.font = UIFont.systemFont(ofSize: 14)
        fileContentLabel.textColor = .gray
        fileContentLabel.numberOfLines = 0  // Ограничение на 5 строк
        contentView.addSubview(fileContentLabel)
        
        // Настройка AutoLayout для элементов
        NSLayoutConstraint.activate([
            fileNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            fileNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            fileNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            fileContentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            fileContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            fileContentLabel.topAnchor.constraint(equalTo: fileNameLabel.bottomAnchor, constant: 5),
            fileContentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // Метод для настройки ячейки с данными о файле
    func configure(with file: GistFile) {
        fileNameLabel.text = file.filename
        fileContentLabel.text = file.content ?? "No content available"
    }
}
