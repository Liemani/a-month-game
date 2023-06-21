//
//  ContainerNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

protocol GameObjectNodeContainer: Sequence {

    /// Called to check whether GOMO.goCoord is valid
    /// The goCoord generated inside of app is considered always valid
    /// - Returns whether the coordinate is valid or not. Don't consider whether preceding GO exist or not
    func isValid(_ coord: Coordinate<Int>) -> Bool

    func addGO(_ go: GameObjectNode, to coord: Coordinate<Int>)

    func moveGO(_ go: GameObjectNode, to coord: Coordinate<Int>)

    func gameObjectAtLocation(of touch: UITouch) -> GameObjectNode?

    func contains(_ go: GameObjectNode) -> Bool

}
