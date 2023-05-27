//
//  FieldNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

class FieldNode: SKNode {

    /// - Returns: child GOs that intersects with node
    func gameObjects(at node: SKNode) -> [GameObject] {
        var gosAt = [GameObject]()

        for child in self.children {
            let child = child as! GameObject
            if child.intersects(node) {
                gosAt.append(child)
            }
        }

        return gosAt
    }

}

extension FieldNode: ContainerNode {

    func add(by goMO: GameObjectMO) -> GameObject? {
        let typeID = Int(goMO.typeID)
        guard let go = GameObjectType.new(typeID: typeID) else { return nil }

        go.zPosition = Constant.ZPosition.gameObject

        let position = goMO.tileCoordinate.fieldPoint
        go.position = position

        self.addChild(go)

        return go
    }

    func gameObject(at touch: UITouch) -> GameObject? {
        return self.child(at: touch) as! GameObject?
    }

}
