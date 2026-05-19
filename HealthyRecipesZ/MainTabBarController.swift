//
//  MainTabBarController.swift
//  HealthyRecipesZ
//
//  Created by Codex on 2026/5/15.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupGlassTabBar()
    }

    private func setupTabs() {
        let discover = ViewController()
        discover.tabBarItem = UITabBarItem(
            title: "发现",
            image: UIImage(systemName: "leaf"),
            selectedImage: UIImage(systemName: "leaf.fill")
        )

        let profile = ProfileViewController()
        profile.tabBarItem = UITabBarItem(
            title: "个人",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        let wheel = DecisionWheelViewController()
        wheel.tabBarItem = UITabBarItem(
            title: "轮盘",
            image: UIImage(systemName: "sparkles"),
            selectedImage: UIImage(systemName: "sparkles")
        )

        viewControllers = [discover, wheel, profile]
    }

    private func setupGlassTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.36)
        appearance.shadowColor = UIColor.white.withAlphaComponent(0.36)

        let selectedColor = UIColor(red: 0.17, green: 0.54, blue: 0.33, alpha: 1)
        let normalColor = UIColor(red: 0.43, green: 0.52, blue: 0.47, alpha: 1)
        [appearance.stackedLayoutAppearance, appearance.inlineLayoutAppearance, appearance.compactInlineLayoutAppearance].forEach {
            $0.selected.iconColor = selectedColor
            $0.selected.titleTextAttributes = [.foregroundColor: selectedColor]
            $0.normal.iconColor = normalColor
            $0.normal.titleTextAttributes = [.foregroundColor: normalColor]
        }

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = selectedColor
        tabBar.unselectedItemTintColor = normalColor
        tabBar.isTranslucent = true
    }
}
