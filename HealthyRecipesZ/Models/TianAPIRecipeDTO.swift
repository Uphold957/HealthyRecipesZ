//
//  TianAPIRecipeDTO.swift
//  HealthyRecipesZ
//
//  Created by Codex on 2026/5/15.
//

import Foundation

struct TianAPIRecipeResponse: Decodable {
    let code: Int
    let msg: String
    let result: TianAPIRecipeResult?
}

struct TianAPIRecipeResult: Decodable {
    let curpage: Int?
    let allnum: Int?
    let list: [TianAPIRecipeDTO]

    enum CodingKeys: String, CodingKey {
        case curpage
        case allnum
        case list
        case newslist
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        curpage = try container.decodeIfPresent(Int.self, forKey: .curpage)
        allnum = try container.decodeIfPresent(Int.self, forKey: .allnum)
        list = try container.decodeIfPresent([TianAPIRecipeDTO].self, forKey: .list)
            ?? container.decodeIfPresent([TianAPIRecipeDTO].self, forKey: .newslist)
            ?? []
    }
}

struct TianAPIRecipeDTO: Decodable {
    let id: Int?
    let cpName: String
    let typeName: String?
    let yuanliao: String?
    let tiaoliao: String?
    let zuofa: String?
    let texing: String?
    let tishi: String?

    enum CodingKeys: String, CodingKey {
        case id
        case cpName = "cp_name"
        case typeName = "type_name"
        case yuanliao
        case tiaoliao
        case zuofa
        case texing
        case tishi
    }
}

extension TianAPIRecipeDTO {
    var recipeID: String {
        if let id = id {
            return "tianapi-\(id)"
        }
        return "tianapi-\(cpName.hashValue)"
    }

    var ingredients: [String] {
        let rawText = [yuanliao, tiaoliao]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: "，")

        return splitText(rawText, maxCount: 4)
    }

    var steps: [String] {
        let cleanText = zuofa?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let steps = splitText(cleanText, maxCount: 4)
        return steps.isEmpty ? ["准备食材。", "按菜谱处理食材。", "控制油盐小火烹调。", "装盘后趁热享用。"] : steps
    }

    var descriptionText: String {
        let candidates = [texing, tishi, zuofa]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        return candidates.first ?? "来自 TianAPI 的中文菜谱，包含原料、调料和做法说明。"
    }

    private func splitText(_ text: String, maxCount: Int) -> [String] {
        text
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "<br>", with: "\n")
            .replacingOccurrences(of: "<br/>", with: "\n")
            .components(separatedBy: CharacterSet(charactersIn: "，,；;\n。"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .prefix(maxCount)
            .map { $0.hasSuffix("。") ? $0 : "\($0)。" }
    }
}
