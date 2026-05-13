//
//  RecipeArtworkView.swift
//  HealthyRecipesZ
//
//  Created by Codex on 2026/5/14.
//

import UIKit

final class RecipeArtworkView: UIView {
    private var accentColor = UIColor.systemRed
    private var plateColor = UIColor.systemOrange
    private var garnishColor = UIColor.systemGreen

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(accent: UIColor, plate: UIColor, garnish: UIColor) {
        accentColor = accent
        plateColor = plate
        garnishColor = garnish
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let center = CGPoint(x: rect.midX, y: rect.midY + rect.height * 0.04)
        let plateRect = CGRect(x: rect.width * 0.09, y: rect.height * 0.13, width: rect.width * 0.82, height: rect.height * 0.72)

        drawPlate(in: plateRect, context: context, rect: rect)
        drawFoodItems(around: center, rect: rect)
        drawSteam(above: center, rect: rect)
    }

    private func drawPlate(in plateRect: CGRect, context: CGContext, rect: CGRect) {
        context.setShadow(offset: CGSize(width: 0, height: 18), blur: 28, color: UIColor.black.withAlphaComponent(0.12).cgColor)
        UIColor.white.setFill()
        UIBezierPath(ovalIn: plateRect).fill()
        context.setShadow(offset: .zero, blur: 0)

        plateColor.setFill()
        UIBezierPath(ovalIn: plateRect.insetBy(dx: rect.width * 0.08, dy: rect.height * 0.09)).fill()

        UIColor.white.withAlphaComponent(0.64).setFill()
        UIBezierPath(ovalIn: plateRect.insetBy(dx: rect.width * 0.18, dy: rect.height * 0.17)).fill()
    }

    private func drawFoodItems(around center: CGPoint, rect: CGRect) {
        for index in 0..<7 {
            let angle = CGFloat(index) * .pi * 2 / 7
            let itemCenter = CGPoint(
                x: center.x + cos(angle) * rect.width * 0.21,
                y: center.y + sin(angle) * rect.height * 0.15
            )
            let size = CGSize(width: rect.width * (index % 2 == 0 ? 0.15 : 0.11), height: rect.height * 0.095)
            let itemRect = CGRect(x: itemCenter.x - size.width / 2, y: itemCenter.y - size.height / 2, width: size.width, height: size.height)

            (index % 3 == 0 ? accentColor : garnishColor).withAlphaComponent(index % 2 == 0 ? 0.92 : 0.78).setFill()
            UIBezierPath(roundedRect: itemRect, cornerRadius: min(size.width, size.height) / 2).fill()
        }

        accentColor.withAlphaComponent(0.94).setFill()
        UIBezierPath(ovalIn: CGRect(x: center.x - rect.width * 0.11, y: center.y - rect.height * 0.08, width: rect.width * 0.22, height: rect.height * 0.16)).fill()
    }

    private func drawSteam(above center: CGPoint, rect: CGRect) {
        UIColor.white.withAlphaComponent(0.82).setStroke()
        let steamPath = UIBezierPath()

        for index in 0..<3 {
            let x = center.x - rect.width * 0.12 + CGFloat(index) * rect.width * 0.12
            steamPath.move(to: CGPoint(x: x, y: rect.height * 0.18))
            steamPath.addCurve(
                to: CGPoint(x: x + 10, y: rect.height * 0.04),
                controlPoint1: CGPoint(x: x - 12, y: rect.height * 0.12),
                controlPoint2: CGPoint(x: x + 18, y: rect.height * 0.10)
            )
        }

        steamPath.lineWidth = 4
        steamPath.lineCapStyle = .round
        steamPath.stroke()
    }
}
