//
//  InventoryNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/21.
//

import Foundation
import SpriteKit

class InventoryNode: SKNode {

    var leftHand: SKNode? { return self.children[0].children.first }
    var rightHand: SKNode? { return self.children[Constant.inventoryCellCount].children.first }

    func initialize() {
        let cellTexture = SKTexture(imageNamed: Resource.Name.inventoryCell)

        let inventoryCellPositionGap: CGFloat = (Constant.inventoryCellLastPosition.x - Constant.inventoryCellFirstPosition.x) / CGFloat(Constant.inventoryCellCount - 1)

        for index in 0..<Constant.inventoryCellCount {
            let cell = SKSpriteNode(texture: cellTexture)

            let x = Constant.inventoryCellFirstPosition.x + inventoryCellPositionGap * CGFloat(index)
            let y = Constant.inventoryCellFirstPosition.y

            cell.position = CGPoint(x: x, y: y)
            cell.zPosition = -1.0
            cell.size = Constant.defaultNodeSize

            self.addChild(cell)
        }

        let leftHandTexture = SKTexture(imageNamed: Resource.Name.leftHand)
        let leftHand = SKSpriteNode(texture: leftHandTexture)
        leftHand.position = Constant.inventoryCellFirstPosition
        leftHand.alpha = 0.5
        self.addChild(leftHand)

        let rightHandTexture = SKTexture(imageNamed: Resource.Name.rightHand)
        let rightHand = SKSpriteNode(texture: rightHandTexture)
        rightHand.position = Constant.inventoryCellLastPosition
        rightHand.alpha = 0.5
        self.addChild(rightHand)
    }

    func gameObject(at touch: UITouch) -> SKNode? {
        let touchPoint = touch.location(in: self)

        for index in 0..<Constant.inventoryCellCount {
            if let gameObject = self.children[index].children.first,
               gameObject.parent!.contains(touchPoint) {
                return gameObject
            }
        }

        return nil
    }

}
