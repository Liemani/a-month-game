//
//  CraftObject.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/25.
//

import Foundation
import SpriteKit

class CraftObject: SKSpriteNode {

    var gameObjectType: GameObjectType = .none

    func set(_ goType: GameObjectType) {
        self.texture = goType.texture
        self.gameObjectType = goType
    }

    func activate() {
        self.alpha = 0.5
    }

    func deactivate() {
        self.alpha = 1.0
    }

}
