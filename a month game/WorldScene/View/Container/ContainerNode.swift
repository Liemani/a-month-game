//
//  ContainerNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

protocol ContainerNode: SKNode {

    /// - Returns whether the coordinate is valid or not. Don't consider whether preceding GO exist or not
    func isVaid(_ coord: Coordinate<Int>) -> Bool

    func addGO(_ go: GameObject, to coord: Coordinate<Int>)

    func moveGO(_ go: GameObject, to coord: Coordinate<Int>)

    func moveGOMO(from go: GameObject, to coord: Coordinate<Int>)

    func gameObjectAtLocation(of touch: UITouch) -> GameObject?

    func contains(_ go: GameObject) -> Bool

}
