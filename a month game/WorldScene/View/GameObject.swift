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

    // MARK: property to be overriden
    var isWalkable: Bool { return true }
    var isPickable: Bool { return true }

    func interact(leftHand: GameObject?, rightHand: GameObject?) {

    }

    var typeID: Int {
        let objectIdentifier = ObjectIdentifier(type(of: self))
        return Resource.gameObjectTypeIDToResource[objectIdentifier]!.typeID
    }

}
