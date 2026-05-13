//
//  RecipeDetailViews.swift
//  HealthyRecipesZ
//
//  Created by Codex on 2026/5/14.
//

import UIKit

final class CapsuleLabel: UILabel {
    override var tintColor: UIColor! {
        didSet {
            textColor = tintColor
            backgroundColor = tintColor.withAlphaComponent(0.12)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .systemFont(ofSize: 13, weight: .bold)
        textAlignment = .center
        layer.cornerRadius = 14
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class InfoPill: UILabel {
    init(text: String, color: UIColor) {
        super.init(frame: .zero)
        self.text = text
        font = .systemFont(ofSize: 12, weight: .semibold)
        textColor = color
        textAlignment = .center
        backgroundColor = color.withAlphaComponent(0.10)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class IngredientView: UIView {
    init(text: String, color: UIColor) {
        super.init(frame: .zero)
        let dot = UIView()
        let label = UILabel()

        dot.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        dot.backgroundColor = color
        dot.layer.cornerRadius = 4
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 0.24, green: 0.31, blue: 0.27, alpha: 1)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8

        addSubview(dot)
        addSubview(label)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 22),
            dot.leadingAnchor.constraint(equalTo: leadingAnchor),
            dot.centerYAnchor.constraint(equalTo: centerYAnchor),
            dot.widthAnchor.constraint(equalToConstant: 8),
            dot.heightAnchor.constraint(equalToConstant: 8),
            label.leadingAnchor.constraint(equalTo: dot.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class StepView: UIView {
    init(number: Int, text: String, color: UIColor) {
        super.init(frame: .zero)
        let numberLabel = UILabel()
        let textLabel = UILabel()

        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.text = "\(number)"
        numberLabel.font = .systemFont(ofSize: 11, weight: .bold)
        numberLabel.textColor = .white
        numberLabel.textAlignment = .center
        numberLabel.backgroundColor = color
        numberLabel.layer.cornerRadius = 10
        numberLabel.layer.masksToBounds = true

        textLabel.text = text
        textLabel.font = .systemFont(ofSize: 12, weight: .regular)
        textLabel.textColor = UIColor(red: 0.26, green: 0.32, blue: 0.28, alpha: 1)
        textLabel.numberOfLines = 2
        textLabel.lineBreakMode = .byTruncatingTail

        addSubview(numberLabel)
        addSubview(textLabel)

        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            numberLabel.widthAnchor.constraint(equalToConstant: 20),
            numberLabel.heightAnchor.constraint(equalToConstant: 20),
            textLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 7),
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
