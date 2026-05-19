//
//  DecisionWheelPreset.swift
//  HealthyRecipesZ
//
//  Created by Codex on 2026/5/20.
//

import Foundation

enum DecisionWheelMode: String, Codable, CaseIterable {
    case food
    case restaurant

    var title: String {
        switch self {
        case .food: return "随机美食"
        case .restaurant: return "随机餐厅"
        }
    }
}

struct DecisionWheelPreset: Codable, Equatable {
    let id: UUID
    var tag: String
    var mode: DecisionWheelMode
    var items: [String]

    init(id: UUID = UUID(), tag: String, mode: DecisionWheelMode, items: [String]) {
        self.id = id
        self.tag = tag
        self.mode = mode
        self.items = items
    }
}
