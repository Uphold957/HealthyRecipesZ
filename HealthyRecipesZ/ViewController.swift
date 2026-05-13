//
//  ViewController.swift
//  HealthyRecipesZ
//
//  Created by 张佳乔 on 2026/5/14.
//

import UIKit

final class ViewController: UIViewController {
    private let viewModel = RecipeFeedViewModel()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.reuseIdentifier)
        return collectionView
    }()

    private let pageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor(red: 0.18, green: 0.33, blue: 0.26, alpha: 1)
        label.textAlignment = .center
        label.backgroundColor = UIColor.white.withAlphaComponent(0.84)
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.94, green: 0.98, blue: 0.94, alpha: 1)
        setupLayout()
        updatePageLabel(index: 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = collectionView.bounds.size
        layout.invalidateLayout()
    }

    private func setupLayout() {
        view.addSubview(collectionView)
        view.addSubview(pageLabel)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            pageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            pageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            pageLabel.widthAnchor.constraint(equalToConstant: 70),
            pageLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    private func updatePageLabel(index: Int) {
        pageLabel.text = viewModel.pageText(for: index)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRecipes
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.reuseIdentifier, for: indexPath) as? RecipeCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.cellViewModel(at: indexPath.item))
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.y / max(scrollView.bounds.height, 1)))
        updatePageLabel(index: viewModel.normalizedIndex(page))
    }
}
