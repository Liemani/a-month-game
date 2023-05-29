//
//  CraftCell.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/28.
//

import Foundation
import SpriteKit

class CraftCell: SKSpriteNode {

    func setUp() {
        self.zPosition = Constant.ZPosition.craftCell
        self.size = Constant.defaultNodeSize
        self.zPosition = Constant.ZPosition.craftCell
        self.alpha = 0.2

        self.addGO(parent: self)
    }

    func addGO(parent: SKNode) {
        let texture = GameObjectType.none.texture
        let craftObject = CraftObject(texture: texture)
        craftObject.size = Constant.defaultNodeSize
        craftObject.zPosition = Constant.ZPosition.craftObject
        parent.addChild(craftObject)
    }

}
