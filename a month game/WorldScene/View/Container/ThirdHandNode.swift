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

    func add(by goMO: GameObjectMO) -> GameObject? {
        let typeID = Int(goMO.typeID)
        guard let go = GameObjectType.new(typeID: typeID) else { return nil }

        go.zPosition = Constant.ZPosition.gameObject
        go.alpha = 0.5

        self.addChild(go)

        return go
    }

    func gameObject(at touch: UITouch) -> GameObject? {
        return self.children.first as! GameObject?
    }

}
