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

// TODO: move to GameObject
//// MARK: - GameObjectMO
//extension GameObjectMO {
//
//    /// - Returns: Return value is bit flag describing Nth space of clockwise order is possessed.
//    func spareDirections(goMOs: any Sequence<GameObjectMO>) -> [Coordinate<Int>] {
//        var filledSpaceFlags: UInt8 = 0
//
//        let spaceShiftTable: [UInt8] = Constant.spaceShiftTable
//
//        let coord = self.coord
//
//        for goMO in goMOs {
//            let goMO = goMO as! GameObjectMO
//            let goMOCoord = goMO.coord
//            if coord.isAdjacent(to: goMOCoord) {
//                let differenceX = goMOCoord.x - coord.x
//                let differenceY = goMOCoord.y - coord.y
//                let differenceCoord = Coordinate(differenceX, differenceY)
//                guard let direction = Direction9(coord: differenceCoord) else {
//                    continue
//                }
//                filledSpaceFlags |= 0x1 << direction.rawValue
//            }
//        }
//
//        let coordVectorTable = Constant.coordVectorTable
//
//        var spareSpaces: [Coordinate<Int>] = []
//
//        for index in 0..<8 {
//            if (filledSpaceFlags >> index) & 0x1 == 0x0 {
//                spareSpaces.append(coordVectorTable[index])
//            }
//        }
//
//        return spareSpaces
//    }
//
//}

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
        return self.contains(touch.location(in: self.parent!))
    }

    // TODO: 99 move to physics(?) module
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
    // TODO: 99 move to physics(?) module
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
