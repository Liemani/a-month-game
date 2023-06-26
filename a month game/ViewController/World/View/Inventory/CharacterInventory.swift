//
//  InventoryNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/21.
//

import Foundation
import SpriteKit

class CharacterInventory: Inventory {

    var leftHandGO: GameObject? { self.children.first!.children.first as! GameObject? }
    var rightHandGO: GameObject? { self.children.last!.children.first as! GameObject? }

    init(id: Int) {
        var cells: [SKSpriteNode] = []
        cells.reserveCapacity(5)
        let texture = SKTexture(imageNamed: "inventory_cell")
        for _ in 0..<5 {
            let cell = SKSpriteNode(texture: texture)
            cell.size = Constant.defaultNodeSize
            cells.append(cell)
        }

        super.init(id: id,
                   texture: SKTexture(imageNamed: "game_object_none"),
                   cells: cells,
                   cellWidth: Constant.defaultWidth,
                   cellSpacing: Constant.invCellSpacing)

        self.position = Constant.invWindowPosition
        self.size = CGSize()
        self.zPosition = Constant.ZPosition.characterInv
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//          let leftHandTexture = SKTexture(imageNamed: Constant.ResourceName.leftHand)
//          let leftHand = SKSpriteNode(texture: leftHandTexture)
//          leftHand.position = inventoryCellFirstPosition
//          leftHand.size = Constant.defaultNodeSize
//          leftHand.zPosition = Constant.ZPosition.inventoryCellHand
//          leftHand.alpha = 0.5
//          self.addChild(leftHand)
//  
//          let rightHandTexture = SKTexture(imageNamed: Constant.ResourceName.rightHand)
//          let rightHand = SKSpriteNode(texture: rightHandTexture)
//          rightHand.position = inventoryCellLastPosition
//          rightHand.size = Constant.defaultNodeSize
//          rightHand.zPosition = Constant.ZPosition.inventoryCellHand
//          rightHand.alpha = 0.5
//          self.addChild(rightHand)

}