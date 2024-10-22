//
//  GistDetailViewController.swift
//  GistsList
//
//  Created by Кирилл Уваров on 22.10.2024.
//

import UIKit

class GistDetailViewController: UIViewController {
    
    private let gistId: String
    private var gistDetail: GistDetail?
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    init(gistId: String) {
        self.gistId = gistId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchGistDetail()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GistDetailCell.self, forCellWithReuseIdentifier: "GistDetailCell")
    }
    
    private func fetchGistDetail() {
        GitHubAPI.shared.fetchGistDetails(gistId: gistId) { [weak self] result in
            switch result {
            case .success(let gistDetail):
                DispatchQueue.main.async {
                    self?.gistDetail = gistDetail
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch gist detail:", error)
            }
        }
    }
}

extension GistDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Количество файлов
        return gistDetail?.files.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GistDetailCell", for: indexPath) as! GistDetailCell
        
        // Получаем значения файлов как массив GistFile
        if let files = gistDetail?.files {
            let filesArray = Array(files.values) // Преобразуем значения словаря в массив
            let file = filesArray[indexPath.row] // Получаем файл по индексу
            cell.configure(with: file) // Настраиваем ячейку
        }

        return cell
    }
    
    // Добавляем поддержку динамической высоты ячеек
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Получаем файл для расчёта высоты
        if let files = gistDetail?.files {
            let filesArray = Array(files.values)
            let file = filesArray[indexPath.row]
            
            // Рассчитываем высоту для имени файла и содержимого
            let width = collectionView.frame.width - 20 // Оставляем отступы по краям
            
            // Используем кастомный метод для расчёта высоты текста
            let fileNameHeight = heightForText(file.filename, width: width, font: UIFont.boldSystemFont(ofSize: 16))
            let fileContentHeight = heightForText(file.content ?? "No content available", width: width, font: UIFont.systemFont(ofSize: 14))
            
            // Возвращаем размер с учётом высоты текста и дополнительных отступов
            return CGSize(width: width, height: fileNameHeight + fileContentHeight + 30) // 30 для дополнительных отступов
        }

        return CGSize(width: collectionView.frame.width - 20, height: 50) // Дефолтный размер, если что-то пойдет не так
    }
    
    // Вспомогательный метод для расчёта высоты текста
    func heightForText(_ text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
