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
    private let recipes: [Recipe]

    var numberOfRecipes: Int {
        recipes.count
    }

    init(recipes: [Recipe] = RecipeFeedViewModel.defaultRecipes) {
        self.recipes = recipes
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

    static let defaultRecipes: [Recipe] = [
        Recipe(
            title: "番茄虾仁豆腐",
            subtitle: "高蛋白 低脂 家常快手菜",
            duration: "18 分钟",
            calories: "286 kcal",
            protein: "31g 蛋白",
            difficulty: "简单",
            description: "酸甜番茄汤汁裹住嫩豆腐和虾仁，少油烹调也足够下饭。适合晚餐想吃热乎又清爽的时候。",
            ingredients: ["虾仁 160g", "嫩豆腐 1盒", "番茄 2个", "葱花 少许"],
            steps: ["番茄去皮切丁，豆腐切块，虾仁用少许胡椒腌 5 分钟。", "少油炒番茄至出沙，加半碗水煮开。", "放入豆腐和虾仁，小火煮 4 分钟。", "用少许盐调味，撒葱花出锅。"],
            mediaLabel: "视频步骤",
            theme: .tomato
        ),
        Recipe(
            title: "清炒西兰花鸡胸",
            subtitle: "控脂餐桌 常备家常菜",
            duration: "15 分钟",
            calories: "248 kcal",
            protein: "36g 蛋白",
            difficulty: "简单",
            description: "鸡胸肉滑嫩不柴，西兰花保持脆绿。调味克制，突出食材本身的鲜味。",
            ingredients: ["鸡胸 180g", "西兰花 半颗", "蒜 2瓣", "生抽 1勺"],
            steps: ["鸡胸切片，加生抽和淀粉抓匀。", "西兰花焯水 40 秒后捞出。", "蒜末炝锅，放鸡胸快速滑炒至变色。", "加入西兰花翻匀，少许盐调味。"],
            mediaLabel: "图文教程",
            theme: .greens
        ),
        Recipe(
            title: "香菇青菜糙米饭",
            subtitle: "一碗满足 膳食纤维充足",
            duration: "22 分钟",
            calories: "332 kcal",
            protein: "12g 蛋白",
            difficulty: "普通",
            description: "用香菇的鲜味给糙米饭提香，再配青菜增加清爽感。适合工作日午餐便当。",
            ingredients: ["糙米饭 1碗", "香菇 5朵", "小青菜 2颗", "鸡蛋 1个"],
            steps: ["香菇切片，小青菜切段，鸡蛋煎成嫩蛋。", "少油炒香菇至边缘微焦。", "加入糙米饭翻炒，放入青菜。", "最后加入鸡蛋，用生抽和黑胡椒调味。"],
            mediaLabel: "便当视频",
            theme: .grains
        ),
        Recipe(
            title: "冬瓜海带排骨汤",
            subtitle: "清淡少盐 暖胃不油腻",
            duration: "45 分钟",
            calories: "295 kcal",
            protein: "24g 蛋白",
            difficulty: "普通",
            description: "排骨焯水后小火煲汤，冬瓜吸收肉香但口感清透。晚餐配一小碗主食刚刚好。",
            ingredients: ["排骨 250g", "冬瓜 300g", "海带 80g", "姜片 3片"],
            steps: ["排骨冷水下锅焯出浮沫，冲洗干净。", "排骨、姜片加热水小火煮 30 分钟。", "加入冬瓜和海带再煮 12 分钟。", "关火前少盐调味，撇去表面油脂。"],
            mediaLabel: "汤品步骤",
            theme: .soup
        )
    ]
}
