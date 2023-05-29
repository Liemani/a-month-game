//
//  InventoryNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/21.
//

import Foundation
import SpriteKit

class InventoryPane: SKSpriteNode {

    var worldScene: WorldScene { self.scene as! WorldScene }

    var cellCount: Int { Constant.inventoryCellCount }

    var cells: [InventoryCell]!

    var leftHandGO: GameObject? { self.cells[0].children.first as! GameObject? }
    var rightHandGO: GameObject? { self.cells[self.cellCount - 1].children.first as! GameObject? }

    // TODO: 50 clean
    func setUp() {
        self.anchorPoint = CGPoint()
        self.position = Constant.inventoryPanePosition
        self.size = Constant.inventoryPaneSize

        let defaultSize = Constant.defaultSize

        let inventoryCellFirstPosition = CGPoint() + defaultSize / 2.0
        let inventoryCellLastPosition = CGPoint(x: self.size.width - defaultSize / 2.0, y: defaultSize / 2.0)
        let inventoryCellPositionGap = (inventoryCellLastPosition.x - inventoryCellFirstPosition.x) / CGFloat(self.cellCount - 1)

        let cellTexture = SKTexture(imageNamed: Constant.ResourceName.inventoryCell)

        var x = inventoryCellFirstPosition.x
        let y = inventoryCellFirstPosition.y

        var cells: [InventoryCell] = []
        for _ in 0..<self.cellCount {
            let cell = InventoryCell(texture: cellTexture)

            cell.position = CGPoint(x: x, y: y)
            cell.setUp()

            self.addChild(cell)
            cells.append(cell)

            x += inventoryCellPositionGap
        }

        let leftHandTexture = SKTexture(imageNamed: Constant.ResourceName.leftHand)
        let leftHand = SKSpriteNode(texture: leftHandTexture)
        leftHand.position = inventoryCellFirstPosition
        leftHand.zPosition = Constant.ZPosition.inventoryCellHand
        leftHand.alpha = 0.5
        self.addChild(leftHand)

        let rightHandTexture = SKTexture(imageNamed: Constant.ResourceName.rightHand)
        let rightHand = SKSpriteNode(texture: rightHandTexture)
        rightHand.position = inventoryCellLastPosition
        rightHand.zPosition = Constant.ZPosition.inventoryCellHand
        rightHand.alpha = 0.5
        self.addChild(rightHand)

        self.cells = cells
    }

    func cellAtLocation(of touch: UITouch) -> InventoryCell! {
        for cell in self.cells {
            if cell.isAtLocation(of: touch) {
                return cell
            }
        }
        return nil
    }

}

extension InventoryPane: ContainerNode {

    func isVaid(_ coord: Coordinate<Int>) -> Bool {
        guard 0 <= coord.x && coord.x < self.cellCount else {
            return false
        }
        return true
    }

    func addGO(_ go: GameObject, to coord: Coordinate<Int>) {
        self.cells[coord.x].addGO(go)
    }

    func moveGO(_ go: GameObject, to coord: Coordinate<Int>) {
        self.cells[coord.x].moveGO(go)
    }

    func moveGOMO(from go: GameObject, to coord: Coordinate<Int>) {
        let goCoord = GameObjectCoordinate(containerType: .inventory, coordinate: coord)
        self.worldScene.moveGOMO(from: go, to: goCoord)
    }

    func gameObjectAtLocation(of touch: UITouch) -> GameObject? {
        for cell in self.cells {
            if let go = cell.children.first as! GameObject?
                , go.isAtLocation(of: touch) {
                return go
            }
        }
        return nil
    }

    func contains(_ go: GameObject) -> Bool {
        if let cell = go.parent, let container = cell.parent {
            return container == self
        }
        return false
    }

}
