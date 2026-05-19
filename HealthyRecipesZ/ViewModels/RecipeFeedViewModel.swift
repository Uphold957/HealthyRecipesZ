//
//  RecipeFeedViewModel.swift
//  HealthyRecipesZ
//
//  Created by Codex on 2026/5/14.
//

import UIKit

struct RecipeCellViewModel {
    let title: String
    let subtitle: String
    let description: String
    let mediaText: String
    let metaItems: [String]
    let ingredients: [String]
    let steps: [String]
    let accentColor: UIColor
    let plateColor: UIColor
    let garnishColor: UIColor
}

final class RecipeFeedViewModel {
    private let repository: RecipeRepository
    private let searchTerms = ["鸡胸肉", "豆腐", "西兰花", "番茄", "虾仁", "青菜", "排骨", "鱼"]
    private var recipes: [Recipe]
    private var loadedRecipeIDs = Set<String>()
    private var nextSearchIndex = 0
    private var nextPage = 1
    private var isLoading = false

    var numberOfRecipes: Int {
        recipes.count
    }

    init(repository: RecipeRepository = RecipeRepository()) {
        self.repository = repository
        self.recipes = RecipeRepository.localFallbackRecipes
        self.loadedRecipeIDs = Set(recipes.map(\.id))
    }

    init(recipes: [Recipe]) {
        self.repository = RecipeRepository(fallbackRecipes: recipes)
        self.recipes = recipes
        self.loadedRecipeIDs = Set(recipes.map(\.id))
    }

    func loadRecipes(completion: @escaping () -> Void) {
        fetchNextBatch(replaceCurrentRecipes: true, fallbackOnFailure: true, completion: completion)
    }

    func loadMoreRecipesIfNeeded(currentIndex: Int, completion: @escaping (Bool) -> Void) {
        guard currentIndex >= numberOfRecipes - 2 else {
            completion(false)
            return
        }
        fetchNextBatch(replaceCurrentRecipes: false, fallbackOnFailure: false, completion: {
            completion(true)
        })
    }

    func cellViewModel(at index: Int) -> RecipeCellViewModel {
        let recipe = recipes[normalizedIndex(index)]
        let palette = palette(for: recipe.theme)

        return RecipeCellViewModel(
            title: recipe.title,
            subtitle: recipe.subtitle,
            description: recipe.description,
            mediaText: "▶ \(recipe.mediaLabel)",
            metaItems: [recipe.duration, recipe.calories, recipe.protein, recipe.difficulty],
            ingredients: recipe.ingredients,
            steps: recipe.steps,
            accentColor: palette.accent,
            plateColor: palette.plate,
            garnishColor: palette.garnish
        )
    }

    func pageText(for index: Int) -> String {
        "\(normalizedIndex(index) + 1) / \(numberOfRecipes)"
    }

    func normalizedIndex(_ index: Int) -> Int {
        guard numberOfRecipes > 0 else { return 0 }
        return min(max(index, 0), numberOfRecipes - 1)
    }

    private func fetchNextBatch(replaceCurrentRecipes: Bool, fallbackOnFailure: Bool, completion: @escaping () -> Void) {
        guard !isLoading else {
            completion()
            return
        }

        isLoading = true
        let searchTerm = searchTerms[nextSearchIndex % searchTerms.count]
        let page = nextPage
        nextSearchIndex += 1
        if nextSearchIndex % searchTerms.count == 0 {
            nextPage += 1
        }

        repository.fetchRecipes(searchTerm: searchTerm, page: page, fallbackOnFailure: fallbackOnFailure) { [weak self] recipes in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if replaceCurrentRecipes {
                    self.recipes = recipes
                    self.loadedRecipeIDs = Set(recipes.map(\.id))
                } else {
                    let newRecipes = recipes.filter { self.loadedRecipeIDs.insert($0.id).inserted }
                    self.recipes.append(contentsOf: newRecipes)
                }

                self.isLoading = false
                completion()
            }
        }
    }
}

private extension RecipeFeedViewModel {
    struct Palette {
        let accent: UIColor
        let plate: UIColor
        let garnish: UIColor
    }

    func palette(for theme: RecipeTheme) -> Palette {
        switch theme {
        case .tomato:
            return Palette(
                accent: UIColor(red: 0.93, green: 0.29, blue: 0.22, alpha: 1),
                plate: UIColor(red: 1.00, green: 0.90, blue: 0.82, alpha: 1),
                garnish: UIColor(red: 0.20, green: 0.64, blue: 0.38, alpha: 1)
            )
        case .greens:
            return Palette(
                accent: UIColor(red: 0.16, green: 0.60, blue: 0.36, alpha: 1),
                plate: UIColor(red: 0.87, green: 0.96, blue: 0.87, alpha: 1),
                garnish: UIColor(red: 0.95, green: 0.78, blue: 0.22, alpha: 1)
            )
        case .grains:
            return Palette(
                accent: UIColor(red: 0.55, green: 0.42, blue: 0.25, alpha: 1),
                plate: UIColor(red: 0.94, green: 0.91, blue: 0.80, alpha: 1),
                garnish: UIColor(red: 0.23, green: 0.58, blue: 0.32, alpha: 1)
            )
        case .soup:
            return Palette(
                accent: UIColor(red: 0.18, green: 0.55, blue: 0.60, alpha: 1),
                plate: UIColor(red: 0.86, green: 0.96, blue: 0.95, alpha: 1),
                garnish: UIColor(red: 0.54, green: 0.78, blue: 0.48, alpha: 1)
            )
        }
    }

}
