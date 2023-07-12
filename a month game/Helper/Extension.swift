//
//  Extension.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/18.
//

import Foundation
import SpriteKit

extension Notification.Name {
    static let requestPresentPortalSceneViewController = Notification.Name("RequestPortalSceneViewController")
    static let requestPresentWorldSceneViewController = Notification.Name("RequestWorldSceneViewController")
}

// MARK: - Array
extension Array {

    subscript<T>(index: T) -> Element where T: RawRepresentable, T.RawValue == Int {
        get {
            return self[index.rawValue]
        }
        set {
            self[index.rawValue] = newValue
        }
    }

}

// MARK: - SKNode
extension SKNode {

    func setPositionToLocation(of touch: UITouch) {
        let touchPoint = touch.location(in: self.parent!)
        self.position = touchPoint
    }

    func childAtLocation(of touch: UITouch) -> SKNode? {
        let touchPoint = touch.location(in: self)
        for child in self.children {
            if child.contains(touchPoint) {
                return child
            }
        }
        return nil
    }

    var firstIndexFromParent: Int? {
        return self.parent?.children.firstIndex(of: self)
    }

    func isBeing(touched touch: UITouch) -> Bool {
        guard let parent = self.parent else {
            return true
        }

        return self.contains(touch.location(in: parent))
    }

    func isDescendant(_ node: SKNode) -> Bool {
        var parent: SKNode? = self.parent

        while let ancestor = parent {
            if ancestor == node {
                return true
            }

            parent = ancestor.parent
        }

        return false
    }

}

// MARK: - CGPoint
extension CGPoint {

    // MARK: prefix
    static prefix func - (point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }

    // MARK: CGPoint, CGPoint
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs + rhs
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs - rhs
    }

    // MARK: CGPoint, CGVector
    static func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }

    static func += (lhs: inout CGPoint, rhs: CGVector) {
        lhs = lhs + rhs
    }

    static func - (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
    }

    static func -= (lhs: inout CGPoint, rhs: CGVector) {
        lhs = lhs - rhs
    }

    // MARK: CGPoint, Double
    static func + (lhs: CGPoint, rhs: Double) -> CGPoint {
        return CGPoint(x: lhs.x + rhs, y: lhs.y + rhs)
    }

    static func - (lhs: CGPoint, rhs: Double) -> CGPoint {
        return CGPoint(x: lhs.x - rhs, y: lhs.y - rhs)
    }

    static func * (lhs: CGPoint, rhs: Double) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    static func / (lhs: CGPoint, rhs: Double) -> CGPoint {
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    static func < (lhs: CGPoint, rhs: Double) -> Bool {
        return lhs.x < rhs && lhs.y < rhs
    }

    // MARK: Coordinate<Int>
    static func * (lhs: CGPoint, rhs: Coordinate<Int>) -> CGPoint {
        return CGPoint(x: lhs.x * Double(rhs.x), y: lhs.y * Double(rhs.y))
    }

    var vector: CGVector { CGVector(dx: self.x, dy: self.y) }

    var magnitude: CGFloat { (self.x * self.x + self.y * self.y).squareRoot() }

}

extension Double {

    static func <= (lhs: Double, rhs: CGPoint) -> Bool {
        return lhs <= rhs.x && lhs <= rhs.y
    }

}

// MARK: - CGSize
extension CGSize {

    var cgPoint: CGPoint { CGPoint(x: self.width, y: self.height) }

    static func - (lhs: CGSize, rhs: Double) -> CGSize {
        return CGSize(width: lhs.width - rhs, height: lhs.height - rhs)
    }

    static func * (lhs: CGSize, rhs: Double) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }

}

// MARK: - CGVector
extension CGVector {

    var cgPoint: CGPoint { CGPoint(x: self.dx, y: self.dy) }

    static prefix func - (vector: CGVector) -> CGVector {
        return CGVector(dx: -vector.dx, dy: -vector.dy)
    }

    static func * (lhs: CGVector, rhs: Double) -> CGVector {
        return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }

    static func *= (lhs: inout CGVector, rhs: Double) {
        lhs = lhs * rhs
    }

    static func / (lhs: CGVector, rhs: Double) -> CGVector {
        return CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
    }

    var magnitude: CGFloat {
        return (self.dx * self.dx + self.dy * self.dy).squareRoot()
    }

}

extension CGRect {

    static func + (lhs: CGRect, rhs: CGPoint) -> CGRect {
        return CGRect(origin: lhs.origin + rhs, size: lhs.size)
    }

}
