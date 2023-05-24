//
//  FieldNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

class FieldNode: SKNode {

    func gameObjects(at node: SKNode) -> [GameObject] {
        var gameObjectsAt = [GameObject]()

        for child in self.children {
            let child = child as! GameObject
            if child.intersects(node) {
                gameObjectsAt.append(child)
            }
        }

        return gameObjectsAt
    }

}

extension FieldNode: ContainerNode {

    func add(by gameObjectMO: GameObjectMO) -> GameObject? {
        let typeID = Int(gameObjectMO.typeID)
        guard let gameObject = GameObjectType.new(typeID: typeID) else { return nil }

        gameObject.zPosition = Constant.ZPosition.gameObject

        let position = (gameObjectMO.coordinate.toCGPoint() + 0.5) * Constant.defaultSize
        gameObject.position = position

        self.addChild(gameObject)

        return gameObject
    }

    func gameObject(at touch: UITouch) -> GameObject? {
        return self.child(at: touch) as! GameObject?
    }

}
