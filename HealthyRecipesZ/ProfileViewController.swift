//
//  ProfileViewController.swift
//  HealthyRecipesZ
//
//  Created by Codex on 2026/5/15.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.94, green: 0.98, blue: 0.94, alpha: 1)
        setupLayout()
        buildContent()
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 18

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 22),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -22),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -110)
        ])
    }

    private func buildContent() {
        contentStack.addArrangedSubview(headerView())
        contentStack.addArrangedSubview(summaryPanel())
        contentStack.addArrangedSubview(settingsPanel())
    }

    private func headerView() -> UIView {
        let container = panelView()
        let avatar = UILabel()
        let nameLabel = UILabel()
        let subtitleLabel = UILabel()
        let textStack = UIStackView(arrangedSubviews: [nameLabel, subtitleLabel])

        avatar.translatesAutoresizingMaskIntoConstraints = false
        textStack.translatesAutoresizingMaskIntoConstraints = false
        avatar.text = "Z"
        avatar.font = .systemFont(ofSize: 30, weight: .bold)
        avatar.textAlignment = .center
        avatar.textColor = .white
        avatar.backgroundColor = UIColor(red: 0.20, green: 0.62, blue: 0.39, alpha: 1)
        avatar.layer.cornerRadius = 31
        avatar.layer.masksToBounds = true

        nameLabel.text = "张佳乔"
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = UIColor(red: 0.12, green: 0.24, blue: 0.18, alpha: 1)

        subtitleLabel.text = "坚持清淡家常菜 · 第 1 天"
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = UIColor(red: 0.39, green: 0.50, blue: 0.43, alpha: 1)

        textStack.axis = .vertical
        textStack.spacing = 6

        container.addSubview(avatar)
        container.addSubview(textStack)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 116),
            avatar.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            avatar.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 62),
            avatar.heightAnchor.constraint(equalToConstant: 62),
            textStack.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            textStack.centerYAnchor.constraint(equalTo: avatar.centerYAnchor)
        ])

        return container
    }

    private func summaryPanel() -> UIView {
        let container = panelView()
        let title = sectionTitle("健康记录")
        let row = UIStackView(arrangedSubviews: [
            metricView(value: "4", label: "收藏菜谱"),
            metricView(value: "12g", label: "平均蛋白"),
            metricView(value: "286", label: "今日热量")
        ])

        title.translatesAutoresizingMaskIntoConstraints = false
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = 10

        container.addSubview(title)
        container.addSubview(row)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 136),
            title.topAnchor.constraint(equalTo: container.topAnchor, constant: 18),
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 18),
            title.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18),
            row.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            row.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            row.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            row.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -18)
        ])

        return container
    }

    private func settingsPanel() -> UIView {
        let container = panelView()
        let title = sectionTitle("软件设置")
        let stack = UIStackView(arrangedSubviews: [
            settingRow(icon: "bell", title: "做饭提醒", value: "开启"),
            divider(),
            settingRow(icon: "flame", title: "热量目标", value: "1600 kcal"),
            divider(),
            settingRow(icon: "leaf", title: "饮食偏好", value: "清淡少油"),
            divider(),
            settingRow(icon: "info.circle", title: "关于应用", value: "v1.0")
        ])

        title.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical

        container.addSubview(title)
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: container.topAnchor, constant: 18),
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 18),
            title.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18),
            stack.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])

        return container
    }

    private func panelView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.82)
        view.layer.cornerRadius = 22
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.07
        view.layer.shadowRadius = 18
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        return view
    }

    private func sectionTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(red: 0.13, green: 0.24, blue: 0.18, alpha: 1)
        return label
    }

    private func metricView(value: String, label: String) -> UIView {
        let valueLabel = UILabel()
        let titleLabel = UILabel()
        let stack = UIStackView(arrangedSubviews: [valueLabel, titleLabel])

        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 20, weight: .bold)
        valueLabel.textAlignment = .center
        valueLabel.textColor = UIColor(red: 0.18, green: 0.54, blue: 0.34, alpha: 1)

        titleLabel.text = label
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(red: 0.45, green: 0.54, blue: 0.49, alpha: 1)

        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        stack.backgroundColor = UIColor(red: 0.91, green: 0.97, blue: 0.92, alpha: 1)
        stack.layer.cornerRadius = 14
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        return stack
    }

    private func settingRow(icon: String, title: String, value: String) -> UIView {
        let imageView = UIImageView(image: UIImage(systemName: icon))
        let titleLabel = UILabel()
        let valueLabel = UILabel()
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        let row = UIView()

        [imageView, titleLabel, valueLabel, chevron].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview($0)
        }

        imageView.tintColor = UIColor(red: 0.18, green: 0.54, blue: 0.34, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = UIColor(red: 0.17, green: 0.26, blue: 0.21, alpha: 1)
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 14, weight: .medium)
        valueLabel.textColor = UIColor(red: 0.47, green: 0.56, blue: 0.50, alpha: 1)
        chevron.tintColor = UIColor(red: 0.66, green: 0.73, blue: 0.68, alpha: 1)
        chevron.contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 52),
            imageView.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 18),
            imageView.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 22),
            imageView.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 10),
            valueLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            chevron.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 8),
            chevron.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -18),
            chevron.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 10)
        ])

        return row
    }

    private func divider() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.86, green: 0.91, blue: 0.87, alpha: 1)
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
}
