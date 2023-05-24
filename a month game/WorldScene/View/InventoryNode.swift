//
//  InventoryNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/21.
//

import Foundation
import SpriteKit

class InventoryNode: SKNode {

    var inventoryCells: [SKNode]!

    var leftHand: GameObject? { return self.children[0].children.first as! GameObject? }
    var rightHand: GameObject? { return self.children[Constant.inventoryCellCount].children.first as! GameObject? }

    static var inventoryCellCount: Int { return Constant.inventoryCellCount }

    // TODO: what about make init()
    func setUp() {
        let cellTexture = SKTexture(imageNamed: Constant.ResourceName.inventoryCell)

        let inventoryCellPositionGap: CGFloat = (Constant.inventoryCellLastPosition.x - Constant.inventoryCellFirstPosition.x) / CGFloat(Constant.inventoryCellCount - 1)

        var inventoryCells = [SKNode?](repeating: nil, count: InventoryNode.inventoryCellCount)

        for index in 0..<Constant.inventoryCellCount {
            let cell = SKSpriteNode(texture: cellTexture)

            let x = Constant.inventoryCellFirstPosition.x + inventoryCellPositionGap * CGFloat(index)
            let y = Constant.inventoryCellFirstPosition.y

            cell.position = CGPoint(x: x, y: y)
            cell.zPosition = Constant.ZPosition.inventoryCell
            cell.size = Constant.defaultNodeSize

            self.addChild(cell)
            inventoryCells[index] = cell
        }

        self.inventoryCells = (inventoryCells as! [SKNode])

        let leftHandTexture = SKTexture(imageNamed: Constant.ResourceName.leftHand)
        let leftHand = SKSpriteNode(texture: leftHandTexture)
        leftHand.position = Constant.inventoryCellFirstPosition
        leftHand.alpha = 0.5
        self.addChild(leftHand)

        let rightHandTexture = SKTexture(imageNamed: Constant.ResourceName.rightHand)
        let rightHand = SKSpriteNode(texture: rightHandTexture)
        rightHand.position = Constant.inventoryCellLastPosition
        rightHand.alpha = 0.5
        self.addChild(rightHand)
    }

    func inventoryCell(at touch: UITouch) -> SKNode? {
        let touchPoint = touch.location(in: self)

        for index in 0..<Constant.inventoryCellCount {
            let cell = self.children[index]
            if cell.contains(touchPoint) {
                return cell
            }
        }

        return nil
    }

}

extension InventoryNode: ContainerNode {

    func add(by gameObjectMO: GameObjectMO) -> GameObject? {
        let typeID = Int(gameObjectMO.typeID)
        guard let gameObject = GameObjectType.new(typeID: typeID) else { return nil }

        gameObject.zPosition = Constant.ZPosition.gameObject

        let inventoryIndex = Int(gameObjectMO.x)
        guard 0 <= inventoryIndex && inventoryIndex < InventoryNode.inventoryCellCount else { return nil }

        let inventoryCell = self.inventoryCells[inventoryIndex]
        inventoryCell.addChild(gameObject)

        return gameObject
    }

    func gameObject(at touch: UITouch) -> GameObject? {
        let touchPoint = touch.location(in: self)

        for index in 0..<Constant.inventoryCellCount {
            if let gameObject = self.children[index].children.first,
               gameObject.parent!.contains(touchPoint) {
                return gameObject as! GameObject?
            }
        }

        return nil
    }

}
