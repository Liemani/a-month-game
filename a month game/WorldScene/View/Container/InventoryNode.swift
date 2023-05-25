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

    var leftHandGO: GameObject? { return self.children[0].children.first as! GameObject? }
    var rightHandGO: GameObject? { return self.children[Constant.inventoryCellCount].children.first as! GameObject? }

    static var cellCount: Int { return Constant.inventoryCellCount }

    func setUp() {
        let cellTexture = SKTexture(imageNamed: Constant.ResourceName.inventoryCell)

        let defaultSize = Constant.defaultSize
        let inventoryPaneSize = Constant.inventoryPaneSize

        let cellCount = InventoryNode.cellCount

        let inventoryCellFirstPosition = CGPoint() + defaultSize / 2.0
        let inventoryCellLastPosition = CGPoint(x: inventoryPaneSize.width - defaultSize / 2.0, y: defaultSize / 2.0)

        let inventoryCellPositionGap: CGFloat = (inventoryCellLastPosition.x - inventoryCellFirstPosition.x) / CGFloat(cellCount - 1)

        var inventoryCells = [SKNode?](repeating: nil, count: cellCount)

        for index in 0..<cellCount {
            let cell = SKSpriteNode(texture: cellTexture)

            let x = inventoryCellFirstPosition.x + inventoryCellPositionGap * CGFloat(index)
            let y = inventoryCellFirstPosition.y

            cell.position = CGPoint(x: x, y: y)
            cell.zPosition = Constant.ZPosition.inventoryCell
            cell.size = Constant.defaultNodeSize

            self.addChild(cell)
            inventoryCells[index] = cell
        }

        self.inventoryCells = (inventoryCells as! [SKNode])

        let leftHandTexture = SKTexture(imageNamed: Constant.ResourceName.leftHand)
        let leftHand = SKSpriteNode(texture: leftHandTexture)
        leftHand.position = inventoryCellFirstPosition
        leftHand.alpha = 0.5
        self.addChild(leftHand)

        let rightHandTexture = SKTexture(imageNamed: Constant.ResourceName.rightHand)
        let rightHand = SKSpriteNode(texture: rightHandTexture)
        rightHand.position = inventoryCellLastPosition
        rightHand.alpha = 0.5
        self.addChild(rightHand)
    }

    func inventoryCell(at touch: UITouch) -> SKNode? {
        let touchPoint = touch.location(in: self)

        for index in 0..<InventoryNode.cellCount {
            let cell = self.children[index]
            if cell.contains(touchPoint) {
                return cell
            }
        }

        return nil
    }

    var gameObjects: [GameObject] {
        var gos: [GameObject] = []

        for cell in self.inventoryCells {
            guard let go = cell.children.first else { continue }

            gos.append(go as! GameObject)
        }

        return gos
    }

}

extension InventoryNode: ContainerNode {

    func add(by goMO: GameObjectMO) -> GameObject? {
        let typeID = Int(goMO.typeID)
        guard let go = GameObjectType.new(typeID: typeID) else {
            return nil
        }

        go.zPosition = Constant.ZPosition.gameObject

        let inventoryIndex = Int(goMO.x)
        guard 0 <= inventoryIndex && inventoryIndex < InventoryNode.cellCount else {
            return nil
        }

        let inventoryCell = self.inventoryCells[inventoryIndex]
        inventoryCell.addChild(go)

        return go
    }

    func gameObject(at touch: UITouch) -> GameObject? {
        let touchPoint = touch.location(in: self)

        for index in 0..<Constant.inventoryCellCount {
            if let go = self.children[index].children.first,
               go.parent!.contains(touchPoint) {
                return go as! GameObject?
            }
        }

        return nil
    }

}
