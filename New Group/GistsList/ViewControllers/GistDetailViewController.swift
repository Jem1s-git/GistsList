//
//  GistDetailViewController.swift
//  GistsList
//
//  Created by Кирилл Уваров on 22.10.2024.
//

import UIKit
import Combine

class GistDetailViewController: UIViewController {
    
    private let viewModel: GistDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    init(gistId: String) {
        self.viewModel = GistDetailViewModel(gistId: gistId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchGistDetail()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GistDetailCell.self, forCellWithReuseIdentifier: "GistDetailCell")
    }
    
    private func bindViewModel() {
        viewModel.$gistDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension GistDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfFiles
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GistDetailCell", for: indexPath) as! GistDetailCell
        
        if let file = viewModel.file(at: indexPath.row) {
            cell.configure(with: file)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let file = viewModel.file(at: indexPath.row) else {
            return CGSize(width: collectionView.frame.width - 20, height: 50)
        }
        
        let width = collectionView.frame.width - 20
        let fileNameHeight = heightForText(file.filename, width: width, font: UIFont.boldSystemFont(ofSize: 16))
        let fileContentHeight = heightForText(file.content ?? "No content available", width: width, font: UIFont.systemFont(ofSize: 14))
        
        return CGSize(width: width, height: fileNameHeight + fileContentHeight + 30)
    }
    
    private func heightForText(_ text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
