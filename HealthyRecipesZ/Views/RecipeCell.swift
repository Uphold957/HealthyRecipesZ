//
//  RecipeCell.swift
//  HealthyRecipesZ
//
//  Created by Codex on 2026/5/14.
//

import UIKit

final class RecipeCell: UICollectionViewCell {
    static let reuseIdentifier = "RecipeCell"

    private let backgroundGradient = CAGradientLayer()
    private let artworkView = RecipeArtworkView()
    private let mediaBadge = CapsuleLabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let metaStack = UIStackView()
    private let ingredientStack = UIStackView()
    private let stepStack = UIStackView()
    private let contentPanel = UIView()
    private let handleView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradient.frame = contentView.bounds
    }

    func configure(with viewModel: RecipeCellViewModel) {
        backgroundGradient.colors = [
            UIColor.white.cgColor,
            viewModel.plateColor.withAlphaComponent(0.72).cgColor,
            UIColor(red: 0.89, green: 0.96, blue: 0.90, alpha: 1).cgColor
        ]
        artworkView.configure(accent: viewModel.accentColor, plate: viewModel.plateColor, garnish: viewModel.garnishColor)
        mediaBadge.text = viewModel.mediaText
        mediaBadge.tintColor = viewModel.accentColor
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        descriptionLabel.text = viewModel.description

        metaStack.replaceArrangedSubviews(with: viewModel.metaItems.map {
            InfoPill(text: $0, color: viewModel.accentColor)
        })
        ingredientStack.replaceArrangedSubviews(with: viewModel.ingredients.map {
            IngredientView(text: $0, color: viewModel.accentColor)
        })
        stepStack.replaceArrangedSubviews(with: viewModel.steps.enumerated().map {
            StepView(number: $0.offset + 1, text: $0.element, color: viewModel.accentColor)
        })
    }

    private func setupViews() {
        contentView.layer.insertSublayer(backgroundGradient, at: 0)

        setupPanel()
        setupLabels()

        let titleBlock = UIStackView(arrangedSubviews: [mediaBadge, titleLabel, subtitleLabel, metaStack, descriptionLabel])
        titleBlock.translatesAutoresizingMaskIntoConstraints = false
        titleBlock.axis = .vertical
        titleBlock.spacing = 10
        titleBlock.alignment = .fill
        mediaBadge.setContentHuggingPriority(.required, for: .vertical)

        let columns = UIStackView(arrangedSubviews: [ingredientStack, stepStack])
        columns.translatesAutoresizingMaskIntoConstraints = false
        columns.axis = .horizontal
        columns.spacing = 12
        columns.distribution = .fillEqually

        contentView.addSubview(artworkView)
        contentView.addSubview(contentPanel)
        contentPanel.addSubview(handleView)
        contentPanel.addSubview(titleBlock)
        contentPanel.addSubview(columns)

        NSLayoutConstraint.activate([
            artworkView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 54),
            artworkView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            artworkView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.86),
            artworkView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.36),

            contentPanel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentPanel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentPanel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentPanel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.52),

            handleView.topAnchor.constraint(equalTo: contentPanel.topAnchor, constant: 10),
            handleView.centerXAnchor.constraint(equalTo: contentPanel.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 38),
            handleView.heightAnchor.constraint(equalToConstant: 4),

            titleBlock.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 14),
            titleBlock.leadingAnchor.constraint(equalTo: contentPanel.leadingAnchor, constant: 22),
            titleBlock.trailingAnchor.constraint(equalTo: contentPanel.trailingAnchor, constant: -22),

            mediaBadge.widthAnchor.constraint(lessThanOrEqualToConstant: 112),
            mediaBadge.heightAnchor.constraint(equalToConstant: 28),
            metaStack.heightAnchor.constraint(equalToConstant: 34),

            columns.topAnchor.constraint(equalTo: titleBlock.bottomAnchor, constant: 14),
            columns.leadingAnchor.constraint(equalTo: titleBlock.leadingAnchor),
            columns.trailingAnchor.constraint(equalTo: titleBlock.trailingAnchor),
            columns.bottomAnchor.constraint(lessThanOrEqualTo: contentPanel.safeAreaLayoutGuide.bottomAnchor, constant: -14)
        ])
    }

    private func setupPanel() {
        artworkView.translatesAutoresizingMaskIntoConstraints = false
        contentPanel.translatesAutoresizingMaskIntoConstraints = false
        contentPanel.backgroundColor = UIColor.white.withAlphaComponent(0.88)
        contentPanel.layer.cornerRadius = 24
        contentPanel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentPanel.layer.shadowColor = UIColor.black.cgColor
        contentPanel.layer.shadowOpacity = 0.08
        contentPanel.layer.shadowRadius = 22
        contentPanel.layer.shadowOffset = CGSize(width: 0, height: -8)

        handleView.translatesAutoresizingMaskIntoConstraints = false
        handleView.backgroundColor = UIColor(red: 0.75, green: 0.84, blue: 0.77, alpha: 1)
        handleView.layer.cornerRadius = 2
    }

    private func setupLabels() {
        [mediaBadge, titleLabel, subtitleLabel, descriptionLabel, metaStack, ingredientStack, stepStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        titleLabel.font = .systemFont(ofSize: 31, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.13, green: 0.24, blue: 0.18, alpha: 1)
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.82

        subtitleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        subtitleLabel.textColor = UIColor(red: 0.36, green: 0.50, blue: 0.41, alpha: 1)
        subtitleLabel.numberOfLines = 1
        subtitleLabel.adjustsFontSizeToFitWidth = true

        descriptionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.textColor = UIColor(red: 0.28, green: 0.34, blue: 0.30, alpha: 1)
        descriptionLabel.numberOfLines = 3
        descriptionLabel.lineBreakMode = .byTruncatingTail

        metaStack.axis = .horizontal
        metaStack.spacing = 8
        metaStack.distribution = .fillEqually

        ingredientStack.axis = .vertical
        ingredientStack.spacing = 7

        stepStack.axis = .vertical
        stepStack.spacing = 8
    }
}

private extension UIStackView {
    func replaceArrangedSubviews(with views: [UIView]) {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        views.forEach(addArrangedSubview)
    }
}
