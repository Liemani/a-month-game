//
//  GameObject.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation
import SpriteKit

// MARK: - class GameObject
class GameObject: SKSpriteNode {

    var worldScene: WorldScene { return self.scene as! WorldScene }

    var objectIdentifier: ObjectIdentifier {
        return ObjectIdentifier(type(of: self))
    }

    // MARK: property to be overriden
    var isWalkable: Bool { return true }
    var isPickable: Bool { return true }

}
