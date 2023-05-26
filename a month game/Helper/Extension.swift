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

    subscript<T>(index: T) -> Element where T: RawRepresentable, T.RawValue == Int {
        get {
            return self[index.rawValue]
        }
        set {
            self[index.rawValue] = newValue
        }
    }

}

// MARK: - GameObjectMO
extension GameObjectMO {

    var containerTypeRawValue: Int? {
        let containerTypeRawValue = Int(self.containerID)

        return 0 <= containerTypeRawValue && containerTypeRawValue < ContainerType.caseCount
            ? containerTypeRawValue
            : nil
    }

    var containerType: ContainerType? {
        return ContainerType(rawValue: Int(self.containerID))
    }

    // TODO: 0 If this caller should use gameObjectCoordinate
    var coordinate: Coordinate<Int> {
        let x = Int(self.x)
        let y = Int(self.y)

        return Coordinate(x, y)
    }

    var gameObjectCoordinate: GameObjectCoordinate? {
        guard let cType = self.containerType else {
            return nil
        }

        let x = Int(self.x)
        let y = Int(self.y)

        return GameObjectCoordinate(containerType: cType, x: x, y: y)
    }

    // TODO: clean after implementing GameObject.interact()
    func setUp(gameObjectType: GameObjectType, containerType: ContainerType, x: Int, y: Int) {
        self.id = Int32(IDGenerator.generate())
        self.typeID = Int32(gameObjectType.rawValue)
        self.containerID = Int32(containerType.rawValue)
        self.x = Int32(x)
        self.y = Int32(y)
    }

}

// MARK: - SKNode
extension SKNode {

    func child(at touch: UITouch) -> SKNode? {
        let touchLocation = touch.location(in: self)
        for child in self.children {
            if child.contains(touchLocation) {
                return child
            }
        }

        return nil
    }

    var firstIndexFromParent: Int? {
        return self.parent?.children.firstIndex(of: self)
    }

    // TODO: move to physics(?) module
    /// - Returns: true if collision resolved else false
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
    // TODO: move to physics(?) module
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
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
        return CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }

    // MARK: CGPoint, Double
    static func + (lhs: CGPoint, rhs: Double) -> CGPoint {
        return CGPoint(x: lhs.x + rhs, y: lhs.y + rhs)
    }

    static func * (lhs: CGPoint, rhs: Double) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
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

}

// MARK: - CGSize
extension CGSize {

    static func - (lhs: CGSize, rhs: Double) -> CGSize {
        return CGSize(width: lhs.width - rhs, height: lhs.height - rhs)
    }

    static func * (lhs: CGSize, rhs: Double) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
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
