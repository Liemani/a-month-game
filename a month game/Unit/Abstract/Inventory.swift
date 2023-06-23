//
//  Container.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

protocol Inventory: SKNode, Sequence {

    /// Called to check whether GOMO.goCoord is valid
    /// The goCoord generated inside of app is considered always valid
    /// - Returns whether the coordinate is valid or not. Don't consider whether preceding GO exist or not
    func isValid(index: Int) -> Bool

    func add(_ go: GameObject, to index: Int)

    func move(_ go: GameObject, to index: Int)

    func goAtLocation(of touch: UITouch) -> GameObject?

    func contains(_ go: GameObject) -> Bool

}
