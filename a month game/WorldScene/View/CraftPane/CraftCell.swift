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
        let go = GameObject.new(from: 0)!
        parent.addChild(go)
    }

}
