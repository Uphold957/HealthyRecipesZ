//
//  DecisionWheelViewController.swift
//  HealthyRecipesZ
//
//  Created by Codex on 2026/5/20.
//

import UIKit

final class DecisionWheelViewController: UIViewController {
    private let viewModel = DecisionWheelViewModel()
    private let wheelView = DecisionWheelView()
    private let pointerView = WheelPointerView()
    private let resultPanel = UIView()
    private let resultLabel = UILabel()
    private let itemTextView = UITextView()
    private let tagField = UITextField()
    private let presetStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.94, green: 0.98, blue: 0.94, alpha: 1)
        setupLayout()
        setupKeyboardDismissGesture()
        applyCurrentState()
    }

    private func setupLayout() {
        let scrollView = UIScrollView()
        let contentStack = UIStackView()
        let spinButton = UIButton(type: .system)
        let saveButton = UIButton(type: .system)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        wheelView.translatesAutoresizingMaskIntoConstraints = false
        pointerView.translatesAutoresizingMaskIntoConstraints = false
        resultPanel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTextView.translatesAutoresizingMaskIntoConstraints = false
        tagField.translatesAutoresizingMaskIntoConstraints = false
        presetStack.translatesAutoresizingMaskIntoConstraints = false

        resultPanel.backgroundColor = UIColor(red: 0.10, green: 0.25, blue: 0.16, alpha: 0.92)
        resultPanel.layer.cornerRadius = 20
        resultPanel.layer.shadowColor = UIColor.black.cgColor
        resultPanel.layer.shadowOpacity = 0.12
        resultPanel.layer.shadowRadius = 16
        resultPanel.layer.shadowOffset = CGSize(width: 0, height: 8)

        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 24, weight: .heavy)
        resultLabel.textColor = .white
        resultLabel.numberOfLines = 2
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.minimumScaleFactor = 0.72
        resultPanel.addSubview(resultLabel)

        itemTextView.font = .systemFont(ofSize: 16, weight: .semibold)
        itemTextView.textColor = UIColor(red: 0.12, green: 0.24, blue: 0.18, alpha: 1)
        itemTextView.backgroundColor = UIColor.white.withAlphaComponent(0.82)
        itemTextView.layer.cornerRadius = 16
        itemTextView.layer.borderWidth = 1
        itemTextView.layer.borderColor = UIColor(red: 0.74, green: 0.84, blue: 0.77, alpha: 1).cgColor
        itemTextView.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        itemTextView.delegate = self

        tagField.placeholder = "标签名称，例如：周末聚餐"
        tagField.font = .systemFont(ofSize: 15, weight: .medium)
        tagField.textColor = UIColor(red: 0.12, green: 0.24, blue: 0.18, alpha: 1)
        tagField.backgroundColor = UIColor.white.withAlphaComponent(0.82)
        tagField.layer.cornerRadius = 14
        tagField.layer.borderWidth = 1
        tagField.layer.borderColor = UIColor(red: 0.74, green: 0.84, blue: 0.77, alpha: 1).cgColor
        tagField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        tagField.leftViewMode = .always

        spinButton.setTitle("开始随机", for: .normal)
        spinButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        spinButton.backgroundColor = UIColor(red: 0.18, green: 0.54, blue: 0.34, alpha: 1)
        spinButton.tintColor = .white
        spinButton.layer.cornerRadius = 18
        spinButton.addTarget(self, action: #selector(spinTapped), for: .touchUpInside)

        saveButton.setTitle("保存为标签", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        saveButton.backgroundColor = UIColor.white.withAlphaComponent(0.86)
        saveButton.tintColor = UIColor(red: 0.18, green: 0.54, blue: 0.34, alpha: 1)
        saveButton.layer.cornerRadius = 16
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        presetStack.axis = .horizontal
        presetStack.spacing = 8
        presetStack.alignment = .leading

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.addArrangedSubview(titleLabel())
        contentStack.addArrangedSubview(helperLabel("输入候选项并保存成标签，下次通过快速标签一键切换。"))
        contentStack.addArrangedSubview(wheelContainer())
        contentStack.addArrangedSubview(resultPanel)
        contentStack.addArrangedSubview(spinButton)
        contentStack.addArrangedSubview(sectionLabel("快速标签"))
        contentStack.addArrangedSubview(presetStack)
        contentStack.addArrangedSubview(sectionLabel("自定义选项"))
        contentStack.addArrangedSubview(helperLabel("每行一个选项，也可以用逗号分隔。"))
        contentStack.addArrangedSubview(itemTextView)
        contentStack.addArrangedSubview(tagField)
        contentStack.addArrangedSubview(saveButton)

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 22),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 22),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -22),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -110),
            resultPanel.heightAnchor.constraint(equalToConstant: 70),
            resultLabel.leadingAnchor.constraint(equalTo: resultPanel.leadingAnchor, constant: 18),
            resultLabel.trailingAnchor.constraint(equalTo: resultPanel.trailingAnchor, constant: -18),
            resultLabel.centerYAnchor.constraint(equalTo: resultPanel.centerYAnchor),
            spinButton.heightAnchor.constraint(equalToConstant: 52),
            itemTextView.heightAnchor.constraint(equalToConstant: 130),
            tagField.heightAnchor.constraint(equalToConstant: 48),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func wheelContainer() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(wheelView)
        container.addSubview(pointerView)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalTo: container.widthAnchor),
            wheelView.topAnchor.constraint(equalTo: container.topAnchor),
            wheelView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            wheelView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            wheelView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            pointerView.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            pointerView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            pointerView.widthAnchor.constraint(equalToConstant: 52),
            pointerView.heightAnchor.constraint(equalToConstant: 52)
        ])

        return container
    }

    private func applyCurrentState() {
        itemTextView.text = viewModel.itemText
        resultLabel.text = viewModel.selectedResult ?? "转一下，交给今天的胃口"
        wheelView.configure(items: viewModel.items)
        rebuildPresetButtons()
    }

    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    private func rebuildPresetButtons() {
        presetStack.arrangedSubviews.forEach {
            presetStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for (index, preset) in viewModel.presets.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(preset.tag, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .heavy)
            button.backgroundColor = UIColor(red: 0.18, green: 0.54, blue: 0.34, alpha: 1)
            button.tintColor = .white
            button.layer.cornerRadius = 16
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 84).isActive = true
            button.heightAnchor.constraint(equalToConstant: 38).isActive = true
            button.tag = index
            button.addTarget(self, action: #selector(presetTapped(_:)), for: .touchUpInside)
            presetStack.addArrangedSubview(button)
        }
    }

    @objc private func spinTapped() {
        view.endEditing(true)
        viewModel.updateItems(from: itemTextView.text)
        wheelView.configure(items: viewModel.items)
        guard let resultIndex = viewModel.randomIndex() else {
            resultLabel.text = viewModel.spinResult()
            return
        }
        resultLabel.text = "转盘加速中..."
        wheelView.spin(to: resultIndex) { [weak self] in
            guard let self = self else { return }
            self.resultLabel.text = self.viewModel.result(at: resultIndex)
        }
    }

    @objc private func saveTapped() {
        view.endEditing(true)
        viewModel.updateItems(from: itemTextView.text)
        viewModel.savePreset(tag: tagField.text ?? "")
        tagField.text = nil
        applyCurrentState()
    }

    @objc private func presetTapped(_ sender: UIButton) {
        viewModel.applyPreset(at: sender.tag)
        applyCurrentState()
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func titleLabel() -> UILabel {
        let label = UILabel()
        label.text = "选择轮盘"
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textColor = UIColor(red: 0.13, green: 0.24, blue: 0.18, alpha: 1)
        return label
    }

    private func sectionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 0.22, green: 0.34, blue: 0.27, alpha: 1)
        return label
    }

    private func helperLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor(red: 0.42, green: 0.54, blue: 0.46, alpha: 1)
        label.numberOfLines = 0
        return label
    }
}

extension DecisionWheelViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.updateItems(from: textView.text)
        wheelView.configure(items: viewModel.items)
    }
}

extension DecisionWheelViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        !(touch.view is UIControl)
    }
}
