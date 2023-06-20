//
//  InventoryNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/21.
//

import Foundation
import SpriteKit

class InventoryWindow: LMISpriteNode {

    var cellCount: Int { Constant.inventoryCellCount }

    var cells: [InventoryCell]!

    var leftHandGO: GameObjectNode? { self.cells[0].children.first as! GameObjectNode? }
    var rightHandGO: GameObjectNode? { self.cells[self.cellCount - 1].children.first as! GameObjectNode? }

    // TODO: 50 clean
    func setUp() {
        self.anchorPoint = CGPoint()
        self.position = Constant.invWindowPosition
        self.size = Constant.invWindowSize

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
        leftHand.size = Constant.defaultNodeSize
        leftHand.zPosition = Constant.ZPosition.inventoryCellHand
        leftHand.alpha = 0.5
        self.addChild(leftHand)

        let rightHandTexture = SKTexture(imageNamed: Constant.ResourceName.rightHand)
        let rightHand = SKSpriteNode(texture: rightHandTexture)
        rightHand.position = inventoryCellLastPosition
        rightHand.size = Constant.defaultNodeSize
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

extension InventoryWindow: InventoryNode {

    func isValid(_ coord: Coordinate<Int>) -> Bool {
        guard 0 <= coord.x && coord.x < self.cellCount else {
            return false
        }
        return true
    }

    func addGO(_ go: GameObjectNode, to coord: Coordinate<Int>) {
        self.cells[coord.x].addGO(go)
    }

    func moveGO(_ go: GameObjectNode, to coord: Coordinate<Int>) {
        self.cells[coord.x].moveGO(go)
    }

    func gameObjectAtLocation(of touch: UITouch) -> GameObjectNode? {
        for cell in self.cells {
            if let go = cell.children.first as! GameObjectNode?
                , go.isAtLocation(of: touch) {
                return go
            }
        }
        return nil
    }

    func contains(_ go: GameObjectNode) -> Bool {
        if let cell = go.parent, let container = cell.parent {
            return container == self
        }
        return false
    }

    func makeIterator() -> some IteratorProtocol<GameObjectNode> {
        return CharacterInventoryIterator(self)
    }

}

struct CharacterInventoryIterator: IteratorProtocol {

    let invWindow: InventoryWindow
    var startIndex: Int = 0

    init(_ invWindow: InventoryWindow) {
        self.invWindow = invWindow
    }

    mutating func next() -> GameObjectNode? {
        for index in self.startIndex..<self.invWindow.cellCount {
            let cell = self.invWindow.children[index]
            if let go = cell.children.first as! GameObjectNode? {
                self.startIndex = index + 1
                return go
            }
        }
        return nil
    }

}
