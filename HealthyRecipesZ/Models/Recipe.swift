//
//  Recipe.swift
//  HealthyRecipesZ
//
//  Created by Codex on 2026/5/14.
//

import Foundation

struct Recipe {
    let title: String
    let subtitle: String
    let duration: String
    let calories: String
    let protein: String
    let difficulty: String
    let description: String
    let ingredients: [String]
    let steps: [String]
    let mediaLabel: String
    let theme: RecipeTheme
}

enum RecipeTheme {
    case tomato
    case greens
    case grains
    case soup
}
