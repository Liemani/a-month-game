//
//  InventoryCell.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/28.
//

import Foundation
import SpriteKit

class InventoryCell: LMISpriteNode {

    var isEmpty: Bool { self.children.first == nil }

    func setUp() {
        self.zPosition = Constant.ZPosition.inventoryCell
        self.size = Constant.defaultNodeSize
    }

    func addGO(_ go: GameObjectNode) {
        self.addChild(go)
        go.position = CGPoint()
        go.isUserInteractionEnabled = true
    }

    func moveGO(_ go: GameObjectNode) {
        go.move(toParent: self)
        go.position = CGPoint()
    }

//    func moveGOMO(_ go: GameObjectNode) {
//        let inventory = self.parent as! InventoryWindow
//        let cellIndex = inventory.cells.firstIndex(of: self)!
//        let coord = Coordinate<Int>(cellIndex, 0)
//        inventory.moveGOMO(from: go, to: coord)
//    }

}
