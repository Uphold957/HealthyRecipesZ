//
//  DecisionWheelView.swift
//  HealthyRecipesZ
//
//  Created by Codex on 2026/5/20.
//

import UIKit

final class DecisionWheelView: UIView {
    private var items: [String] = []
    private var currentRotation: CGFloat = 0
    private let colors: [UIColor] = [
        UIColor(red: 0.25, green: 0.67, blue: 0.43, alpha: 1),
        UIColor(red: 0.96, green: 0.55, blue: 0.35, alpha: 1),
        UIColor(red: 0.96, green: 0.78, blue: 0.36, alpha: 1),
        UIColor(red: 0.35, green: 0.68, blue: 0.72, alpha: 1),
        UIColor(red: 0.72, green: 0.58, blue: 0.36, alpha: 1)
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(items: [String]) {
        self.items = items
        setNeedsDisplay()
    }

    func spin(to index: Int, completion: @escaping () -> Void) {
        guard items.indices.contains(index) else {
            completion()
            return
        }

        let sliceAngle = 2 * CGFloat.pi / CGFloat(items.count)
        let targetSliceCenter = -CGFloat.pi / 2 + CGFloat(index) * sliceAngle + sliceAngle / 2
        let pointerAngle = -CGFloat.pi / 2
        let normalizedCurrentRotation = currentRotation.truncatingRemainder(dividingBy: 2 * .pi)
        let baseTargetRotation = pointerAngle - targetSliceCenter
        let normalizedDelta = positiveRemainder(baseTargetRotation - normalizedCurrentRotation, 2 * .pi)
        let fastTurns = CGFloat(Int.random(in: 7...9)) * 2 * .pi
        let finalRotation = currentRotation + fastTurns + normalizedDelta

        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.values = [
            currentRotation,
            currentRotation + fastTurns * 0.42,
            currentRotation + fastTurns * 0.74,
            finalRotation
        ]
        animation.keyTimes = [0, 0.22, 0.52, 1]
        animation.duration = 2.25
        animation.timingFunctions = [
            CAMediaTimingFunction(name: .easeIn),
            CAMediaTimingFunction(name: .linear),
            CAMediaTimingFunction(name: .easeOut)
        ]
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        layer.add(animation, forKey: "wheelSpin")
        currentRotation = finalRotation

        DispatchQueue.main.asyncAfter(deadline: .now() + animation.duration) {
            self.transform = CGAffineTransform(rotationAngle: finalRotation)
            self.layer.removeAnimation(forKey: "wheelSpin")
            completion()
        }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), !items.isEmpty else { return }
        let size = min(rect.width, rect.height)
        let wheelRect = CGRect(x: rect.midX - size / 2, y: rect.midY - size / 2, width: size, height: size).insetBy(dx: 6, dy: 6)
        let center = CGPoint(x: wheelRect.midX, y: wheelRect.midY)
        let radius = wheelRect.width / 2
        let angle = 2 * CGFloat.pi / CGFloat(items.count)

        for index in items.indices {
            let startAngle = -CGFloat.pi / 2 + CGFloat(index) * angle
            let endAngle = startAngle + angle
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            colors[index % colors.count].setFill()
            path.fill()
        }

        drawLabels(center: center, radius: radius, angle: angle, context: context)
        UIColor.white.withAlphaComponent(0.92).setFill()
        UIBezierPath(ovalIn: CGRect(x: center.x - 28, y: center.y - 28, width: 56, height: 56)).fill()
    }

    private func drawLabels(center: CGPoint, radius: CGFloat, angle: CGFloat, context: CGContext) {
        for (index, item) in items.enumerated() {
            context.saveGState()
            let text = String(item.prefix(6)) as NSString
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .heavy),
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black.withAlphaComponent(0.34),
                .strokeWidth: -3.0
            ]
            let labelAngle = -CGFloat.pi / 2 + CGFloat(index) * angle + angle / 2
            context.translateBy(x: center.x + cos(labelAngle) * radius * 0.55, y: center.y + sin(labelAngle) * radius * 0.55)
            context.rotate(by: labelAngle + CGFloat.pi / 2)
            let textSize = text.size(withAttributes: attributes)
            text.draw(at: CGPoint(x: -textSize.width / 2, y: -textSize.height / 2), withAttributes: attributes)
            context.restoreGState()
        }
    }

    private func positiveRemainder(_ value: CGFloat, _ divisor: CGFloat) -> CGFloat {
        let remainder = value.truncatingRemainder(dividingBy: divisor)
        return remainder >= 0 ? remainder : remainder + divisor
    }
}

final class WheelPointerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let centerX = rect.midX
        let tip = CGPoint(x: centerX, y: 8)
        let left = CGPoint(x: centerX - 18, y: 40)
        let right = CGPoint(x: centerX + 18, y: 40)

        let pointer = UIBezierPath()
        pointer.move(to: tip)
        pointer.addLine(to: left)
        pointer.addLine(to: right)
        pointer.close()

        UIColor(red: 0.10, green: 0.25, blue: 0.16, alpha: 1).setFill()
        pointer.fill()
        UIColor.white.withAlphaComponent(0.95).setStroke()
        pointer.lineWidth = 2
        pointer.stroke()
    }
}
