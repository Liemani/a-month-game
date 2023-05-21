//
//  Extension.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/18.
//

import Foundation
import SpriteKit

// MARK: - Array
extension Array {

    func safeSubscrirpt(_ index: Int) -> Element {
        let index = self.indices.contains(index) ? index : 0
        return self[index]
    }

}

// MARK: - SKNode
extension SKNode {

    func directChild(at touch: UITouch) -> SKNode? {
        let touchLocation = touch.location(in: self)
        for child in self.children {
            if child.contains(touchLocation) {
                return child
            }
        }

        return nil
    }

    // TODO: move
    func getInventoryGameObject(at touch: UITouch) -> SKNode? {
        let touchLocation = touch.location(in: self)
        for cell in self.children {
            if let gameObject = cell.children.first,
               cell.contains(touchLocation) {
                return gameObject
            }
        }

        return nil
    }

    func directNodes(at node: SKNode) -> [SKNode] {
        var array = [SKNode]()

        for child in self.children {
            if child.intersects(node) {
                array.append(child)
            }
        }

        return array
    }

    var firstIndexFromParent: Int? {
        return self.parent?.children.firstIndex(of: self)
    }

    // TODO: move
    /// Return true if collision resolved else false
    func resolveSideCollisionPointWithCircle(ofOrigin circleOrigin: inout CGPoint, andRadius circleRadius: Double) -> Bool {
        let minimalDistanceToCollision = self.frame.width / 2.0 + circleRadius
        if self.position.x - circleOrigin.x < minimalDistanceToCollision
            && circleOrigin.x <= self.position.x
            && self.frame.minY < circleOrigin.y && circleOrigin.y < self.frame.maxY {
            circleOrigin.x = self.frame.minX - circleRadius
            return true
        } else if circleOrigin.x - self.position.x < minimalDistanceToCollision
            && self.position.x <= circleOrigin.x
            && self.frame.minY < circleOrigin.y && circleOrigin.y < self.frame.maxY {
            circleOrigin.x = self.frame.maxX + circleRadius
            return true
        } else if self.position.y - circleOrigin.y < minimalDistanceToCollision
            && circleOrigin.y <= self.position.y
            && self.frame.minX < circleOrigin.x && circleOrigin.x < self.frame.maxX {
            circleOrigin.y = self.frame.minY - circleRadius
            return true
        } else if circleOrigin.y - self.position.y < minimalDistanceToCollision
            && self.position.y <= circleOrigin.y
            && self.frame.minX < circleOrigin.x && circleOrigin.x < self.frame.maxX {
            circleOrigin.y = self.frame.maxY + circleRadius
            return true
        }

        return false
    }

    // NOTE: optimization possible
    // TODO: move
    func resolvePointCollisionPointWithCircle(ofOrigin circleOrigin: inout CGPoint, andRadius circleRadius: Double) {
        if CGVector(dx: circleOrigin.x - self.frame.minX, dy: circleOrigin.y - self.frame.minY).magnitude < circleRadius {
            let xDifference = self.position.x - circleOrigin.x
            let yDifference = self.position.y - circleOrigin.y
            let inclination = yDifference / xDifference
            let yIntercept = (self.position.x * circleOrigin.y - circleOrigin.x * self.position.y) / xDifference
            let temp = yIntercept - self.frame.minY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - self.frame.minX
            let c = self.frame.minX * self.frame.minX + temp * temp - circleRadius * circleRadius
            circleOrigin.x = (-b - (b * b - a * c).squareRoot()) / a
            circleOrigin.y = inclination * circleOrigin.x + yIntercept
        } else if CGVector(dx: circleOrigin.x - self.frame.maxX, dy: circleOrigin.y - self.frame.minY).magnitude < circleRadius {
            let xDifference = self.position.x - circleOrigin.x
            let yDifference = self.position.y - circleOrigin.y
            let inclination = yDifference / xDifference
            let yIntercept = (self.position.x * circleOrigin.y - circleOrigin.x * self.position.y) / xDifference
            let temp = yIntercept - self.frame.minY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - self.frame.maxX
            let c = self.frame.maxX * self.frame.maxX + temp * temp - circleRadius * circleRadius
            circleOrigin.x = (-b + (b * b - a * c).squareRoot()) / a
            circleOrigin.y = inclination * circleOrigin.x + yIntercept
        } else if CGVector(dx: circleOrigin.x - self.frame.minX, dy: circleOrigin.y - self.frame.maxY).magnitude < circleRadius {
            let xDifference = self.position.x - circleOrigin.x
            let yDifference = self.position.y - circleOrigin.y
            let inclination = yDifference / xDifference
            let yIntercept = (self.position.x * circleOrigin.y - circleOrigin.x * self.position.y) / xDifference
            let temp = yIntercept - self.frame.maxY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - self.frame.minX
            let c = self.frame.minX * self.frame.minX + temp * temp - circleRadius * circleRadius
            circleOrigin.x = (-b - (b * b - a * c).squareRoot()) / a
            circleOrigin.y = inclination * circleOrigin.x + yIntercept
        } else if CGVector(dx: circleOrigin.x - self.frame.maxX, dy: circleOrigin.y - self.frame.maxY).magnitude < circleRadius {
            let xDifference = self.position.x - circleOrigin.x
            let yDifference = self.position.y - circleOrigin.y
            let inclination = yDifference / xDifference
            let yIntercept = (self.position.x * circleOrigin.y - circleOrigin.x * self.position.y) / xDifference
            let temp = yIntercept - self.frame.maxY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - self.frame.maxX
            let c = self.frame.maxX * self.frame.maxX + temp * temp - circleRadius * circleRadius
            circleOrigin.x = (-b + (b * b - a * c).squareRoot()) / a
            circleOrigin.y = inclination * circleOrigin.x + yIntercept
        }
    }

}

// MARK: - UITouch
extension UITouch {

    func `is`(onThe node: SKNode) -> Bool {
        guard let parent = node.parent else { return true }

        let touchLocation = self.location(in: parent)

        return node.contains(touchLocation)
    }

}

// MARK: - CGPoint
extension CGPoint {

    // MARK: prefix
    static prefix func - (point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }

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

// MARK: - CGSize
extension CGSize {

    static func - (left: CGSize, right: Double) -> CGSize {
        return CGSize(width: left.width - right, height: left.height - right)
    }

    static func * (left: CGSize, right: Double) -> CGSize {
        return CGSize(width: left.width * right, height: left.height * right)
    }

    func toCGPoint() -> CGPoint {
        return CGPoint(x: self.width, y: self.height)
    }

}

// MARK: - CGVector
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
