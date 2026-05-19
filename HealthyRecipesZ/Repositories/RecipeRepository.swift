//
//  RecipeRepository.swift
//  HealthyRecipesZ
//
//  Created by Codex on 2026/5/15.
//

import Foundation

final class RecipeRepository {
    private let service: RecipeService
    private let fallbackRecipes: [Recipe]

    init(service: RecipeService = RecipeService(), fallbackRecipes: [Recipe] = RecipeRepository.localFallbackRecipes) {
        self.service = service
        self.fallbackRecipes = fallbackRecipes
    }

    func fetchRecipes(searchTerm: String, page: Int, fallbackOnFailure: Bool, completion: @escaping ([Recipe]) -> Void) {
        service.fetchRecipes(searchTerm: searchTerm, page: page) { [fallbackRecipes] result in
            switch result {
            case .success(let remoteRecipes):
                let recipes = remoteRecipes.map(Self.mapToRecipe)
                completion(recipes.isEmpty && fallbackOnFailure ? fallbackRecipes : recipes)
            case .failure:
                completion(fallbackOnFailure ? fallbackRecipes : [])
            }
        }
    }

    private static func mapToRecipe(_ dto: TianAPIRecipeDTO) -> Recipe {
        return Recipe(
            id: dto.recipeID,
            title: dto.cpName,
            subtitle: dto.typeName ?? "中文家常菜",
            duration: "约 30 分钟",
            calories: "营养参考",
            protein: "食材均衡",
            difficulty: "普通",
            description: dto.descriptionText,
            ingredients: Array(dto.ingredients.prefix(4)),
            steps: dto.steps,
            mediaLabel: "中文菜谱",
            imageURL: nil,
            theme: theme(for: dto.recipeID)
        )
    }

    private static func theme(for id: String) -> RecipeTheme {
        let themes: [RecipeTheme] = [.tomato, .greens, .grains, .soup]
        return themes[abs(id.hashValue) % themes.count]
    }

    static let localFallbackRecipes: [Recipe] = [
        Recipe(
            id: "local-tomato-shrimp-tofu",
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
            imageURL: nil,
            theme: .tomato
        ),
        Recipe(
            id: "local-broccoli-chicken",
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
            imageURL: nil,
            theme: .greens
        ),
        Recipe(
            id: "local-mushroom-greens-rice",
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
            imageURL: nil,
            theme: .grains
        ),
        Recipe(
            id: "local-winter-melon-soup",
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
            imageURL: nil,
            theme: .soup
        )
    ]
}
