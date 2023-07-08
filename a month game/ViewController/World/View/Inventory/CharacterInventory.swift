//
//  InventoryNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/21.
//

import Foundation
import SpriteKit

class CharacterInventory: Inventory {

    var leftGO: GameObject? { self.children.first!.children.first as! GameObject? }
    var rightGO: GameObject? { self.children.last!.children.first as! GameObject? }

    init(id: Int) {
        var cells: [InventoryCell] = []
        cells.reserveCapacity(5)

        let cellTexture = SKTexture(imageNamed: Constant.ResourceName.inventoryCell)
        let leftCellTexture = SKTexture(imageNamed: Constant.ResourceName.inventoryCellLeftHand)
        let rightCellTexture = SKTexture(imageNamed: Constant.ResourceName.inventoryCellRightHand)

        let leftCell = InventoryCell(texture: leftCellTexture)
        leftCell.size = Constant.defaultNodeSize
        cells.append(leftCell)

        for _ in 1..<4 {
            let cell = InventoryCell(texture: cellTexture)
            cell.size = Constant.defaultNodeSize
            cells.append(cell)
        }

        let rightCell = InventoryCell(texture: rightCellTexture)
        rightCell.size = Constant.defaultNodeSize
        cells.append(rightCell)

        super.init(id: 0,
                   cells: cells,
                   cellWidth: Constant.defaultWidth,
                   cellSpacing: Constant.invCellSpacing)

        self.position = Constant.invWindowPosition
        self.zPosition = Constant.ZPosition.characterInv
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
