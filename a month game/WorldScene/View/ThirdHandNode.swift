//
//  ThirdHand.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

class ThirdHandNode: SKNode {

}

extension ThirdHandNode: ContainerNode {

    func add(by gameObjectMO: GameObjectMO) -> GameObject? {
        let typeID = Int(gameObjectMO.typeID)
        guard let gameObject = GameObjectType.new(typeID: typeID) else { return nil }

        gameObject.zPosition = Constant.ZPosition.gameObject
        gameObject.alpha = 0.5

        self.addChild(gameObject)

        return gameObject
    }

    func gameObject(at touch: UITouch) -> GameObject? {
        return self.children.first as! GameObject?
    }

}
