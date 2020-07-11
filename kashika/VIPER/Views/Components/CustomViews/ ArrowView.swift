//
//   ArrowView.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/06/08.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

@IBDesignable
final class ArrowView: UIView {

    var start: Position = .left
    var end: Position = .right

    @IBInspectable public var color: UIColor = UIColor.app.label
    @IBInspectable public var lineWidth: CGFloat = 3.0
    @IBInspectable public var headInset: CGFloat = 3.0

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = createPath()
        color.set()

        path.lineWidth = lineWidth
        path.stroke()
    }
}

extension ArrowView {

    func createPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        path.move(to: start.point(for: self.frame.size))
        path.addLine(to: end.point(for: self.frame.size))

        let arrowPoints = end.arrowaPoints(for: self.frame.size, headInset: headInset)
        path.move(to: end.point(for: self.frame.size))
        path.addLine(to: arrowPoints.first)

        path.move(to: end.point(for: self.frame.size))
        path.addLine(to: arrowPoints.second)

        return path
    }
}

extension ArrowView {
    enum Position {

        private static let margin = CGFloat(2)

        case left, top, right, bottom

        func point(for size: CGSize) -> CGPoint {
            switch self {
            case .left:
                return CGPoint(x: Position.margin, y: size.height / 2)
            case .top:
                return CGPoint(x: size.width / 2, y: Position.margin)
            case .bottom:
                return CGPoint(x: size.width / 2, y: size.height - Position.margin)
            case .right:
                return CGPoint(x: size.width - Position.margin, y: size.height / 2)
            }
        }

        func arrowaPoints(for size: CGSize, headInset: CGFloat) -> (first: CGPoint, second: CGPoint) {
            let width = size.width
            let height = size.height
            let margin = Position.margin

            switch self {
            case .left:
                return (CGPoint(x: margin + headInset, y: margin), CGPoint(x: margin + headInset, y: height - margin))
            case .top:
                return (CGPoint(x: margin, y: headInset + margin), CGPoint(x: width - margin, y: headInset + margin))
            case .bottom:
                return (CGPoint(x: margin, y: height - headInset - margin), CGPoint(x: margin, y: height - headInset - margin))
            case .right:
                return (CGPoint(x: width - headInset - margin, y: margin), CGPoint(x: width - headInset - margin, y: height - margin))
            }
        }
    }
}
