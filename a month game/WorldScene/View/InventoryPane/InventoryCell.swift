//
//  InventoryCell.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/28.
//

import Foundation
import SpriteKit

class InventoryCell: SpriteNode {

    var isEmpty: Bool { self.children.first == nil }

    func setUp() {
        self.zPosition = Constant.ZPosition.inventoryCell
        self.size = Constant.defaultNodeSize
    }

    func addGO(_ go: GameObject) {
        self.addChild(go)
        go.position = CGPoint()
        go.isUserInteractionEnabled = true
    }

    func moveGO(_ go: GameObject) {
        go.move(toParent: self)
        go.position = CGPoint()
        go.isUserInteractionEnabled = true
    }

    func moveGOMO(_ go: GameObject) {
        let inventory = self.parent as! InventoryPane
        let cellIndex = inventory.cells.firstIndex(of: self)!
        let coord = Coordinate<Int>(cellIndex, 0)
        inventory.moveGOMO(from: go, to: coord)
    }

}
