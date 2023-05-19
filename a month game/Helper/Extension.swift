//
//  Extension.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/18.
//

import Foundation
import SpriteKit

extension SKNode {

    func child(at touch: UITouch) -> SKNode? {
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)

        return touchedNodes.first
    }

}

extension UITouch {

    func `is`(onThe node: SKNode) -> Bool {
        guard let parent = node.parent else { return true }

        let touchLocation = self.location(in: parent)

        return node.contains(touchLocation)
    }

}

extension CGPoint {

    // MARK: CGPoint, CGPoint
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }

    static func - (left: CGPoint, right: CGPoint) -> CGVector {
        return CGVector(dx: left.x - right.x, dy: left.y - right.y)
    }

    // MARK: CGPoint, Double
    static func + (left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x + right, y: left.y + right)
    }

    static func * (left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }

    // MARK: CGPoint, CGVector
    static func + (left: CGPoint, right: CGVector) -> CGPoint {
        return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
    }

    static func += (left: inout CGPoint, right: CGVector) {
        left = left + right
    }

    static func - (left: CGPoint, right: CGVector) -> CGPoint {
        return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
    }

    static func -= (left: inout CGPoint, right: CGVector) {
        left = left - right
    }

}

extension CGSize {

    static func * (left: CGSize, right: Double) -> CGSize {
        return CGSize(width: left.width * right, height: left.height * right)
    }

}

extension CGVector {

    static prefix func - (vector: CGVector) -> CGVector {
        return CGVector(dx: -vector.dx, dy: -vector.dy)
    }

    static func * (left: CGVector, right: Double) -> CGVector {
        return CGVector(dx: left.dx * right, dy: left.dy * right)
    }

    static func *= (left: inout CGVector, right: Double) {
        left = left * right
    }

    static func / (left: CGVector, right: Double) -> CGVector {
        return CGVector(dx: left.dx / right, dy: left.dy / right)
    }

    var magnitude: CGFloat {
        return (self.dx * self.dx + self.dy * self.dy).squareRoot()
    }

}
