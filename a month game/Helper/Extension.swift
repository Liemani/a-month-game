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

    func nodes(at node: SKNode) -> [SKNode] {
        var array = [SKNode]()

        for child in children {
            if child.intersects(node) {
                array.append(child)
            }
        }

        return array
    }

    func getSideCollisionPointWithCircle(ofOrigin circleOrigin: CGPoint, andRadius circleRadius: Double) -> CGPoint? {
        let minimalDistanceToCollision = self.frame.width / 2.0 + circleRadius
        if self.position.x - circleOrigin.x < minimalDistanceToCollision
            && circleOrigin.x <= self.position.x
            && self.frame.minY < circleOrigin.y && circleOrigin.y < self.frame.maxY {
            return CGPoint(x: self.frame.minX, y: circleOrigin.y)
        } else if circleOrigin.x - self.position.x < minimalDistanceToCollision
            && self.position.x <= circleOrigin.x
            && self.frame.minY < circleOrigin.y && circleOrigin.y < self.frame.maxY {
            return CGPoint(x: self.frame.maxX, y: circleOrigin.y)
        } else if self.position.y - circleOrigin.y < minimalDistanceToCollision
            && circleOrigin.y <= self.position.y
            && self.frame.minX < circleOrigin.x && circleOrigin.x < self.frame.maxX {
            return CGPoint(x: circleOrigin.x, y: self.frame.minY)
        } else if circleOrigin.y - self.position.y < minimalDistanceToCollision
            && self.position.y <= circleOrigin.y
            && self.frame.minX < circleOrigin.x && circleOrigin.x < self.frame.maxX {
            return CGPoint(x: circleOrigin.x, y: self.frame.maxY)
        }

        return nil
    }

    func getPointCollisionPointWithCircle(ofOrigin circleOrigin: CGPoint, andRadius circleRadius: Double) -> CGPoint? {

        return nil
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
