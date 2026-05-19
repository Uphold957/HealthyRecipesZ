//
//  DecisionWheelViewModel.swift
//  HealthyRecipesZ
//
//  Created by Codex on 2026/5/20.
//

import Foundation

final class DecisionWheelViewModel {
    private let storageKey = "decision_wheel_presets"
    private(set) var presets: [DecisionWheelPreset]
    private(set) var mode: DecisionWheelMode
    private(set) var items: [String]
    private(set) var selectedResult: String?

    init() {
        let defaults = DecisionWheelViewModel.defaultPresets
        presets = Self.loadPresets() ?? defaults
        mode = presets.first?.mode ?? .food
        items = presets.first?.items ?? defaults[0].items
    }

    var itemText: String {
        items.joined(separator: "\n")
    }

    func updateItems(from text: String) {
        items = text
            .components(separatedBy: CharacterSet(charactersIn: "\n，,"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    func spinResult() -> String {
        guard let index = randomIndex() else {
            selectedResult = "先添加几个选项"
            return selectedResult ?? ""
        }
        let result = items[index]
        selectedResult = result
        return result
    }

    func randomIndex() -> Int? {
        guard !items.isEmpty else { return nil }
        return Int.random(in: 0..<items.count)
    }

    func result(at index: Int) -> String {
        guard items.indices.contains(index) else {
            selectedResult = "先添加几个选项"
            return selectedResult ?? ""
        }
        selectedResult = items[index]
        return items[index]
    }

    func savePreset(tag: String) {
        let cleanTag = tag.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanTag.isEmpty, !items.isEmpty else { return }

        let preset = DecisionWheelPreset(tag: cleanTag, mode: mode, items: items)
        if let index = presets.firstIndex(where: { $0.tag == cleanTag }) {
            presets[index] = preset
        } else {
            presets.insert(preset, at: 0)
        }
        persist()
    }

    func applyPreset(at index: Int) {
        guard presets.indices.contains(index) else { return }
        let preset = presets[index]
        mode = preset.mode
        items = preset.items
        selectedResult = nil
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(presets) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private static func loadPresets() -> [DecisionWheelPreset]? {
        guard let data = UserDefaults.standard.data(forKey: "decision_wheel_presets") else { return nil }
        return try? JSONDecoder().decode([DecisionWheelPreset].self, from: data)
    }

    private static let defaultPresets = [
        DecisionWheelPreset(tag: "今日吃什么", mode: .food, items: ["番茄虾仁豆腐", "清炒西兰花鸡胸", "香菇青菜糙米饭", "冬瓜海带排骨汤", "牛肉沙拉"]),
        DecisionWheelPreset(tag: "附近餐厅", mode: .restaurant, items: ["轻食沙拉店", "日式定食", "粤式茶餐厅", "牛肉面馆", "健康便当"])
    ]
}
