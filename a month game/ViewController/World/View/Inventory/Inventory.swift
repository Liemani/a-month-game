//
//  Container.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

protocol InventoryProtocol: SKNode, Sequence {

    associatedtype Item
    associatedtype Coord

    func isValid(_ coord: Coord) -> Bool
    func contains(_ item: Item) -> Bool

    func item(at coord: Coord) -> Item?
    func itemAtLocation(of touch: UITouch) -> Item?

    func add(_ item: Item)

}

class Inventory: SKSpriteNode {

    let id: Int

    var cellCount: Int
    let cellWidth: Double
    let cellSpacing: Double

    init(id: Int,
         texture: SKTexture,
         cellWidth: Double,
         cellSpacing: Double) {
        self.id = id
        self.cellCount = 0
        self.cellWidth = cellWidth
        self.cellSpacing = cellSpacing

        super.init(texture: texture, color: .white, size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addCell(_ cell: SKSpriteNode) {
        self.addChild(cell)
        self.cellCount += 1

        let distanceOfCellsCenter = self.cellWidth + self.cellSpacing
        let endCellOffset = distanceOfCellsCenter * Double((self.cellCount - 1) / 2)

        var positionX = -endCellOffset

        for index in 0..<self.cellCount {
            self.children[index].position = CGPoint(x: positionX, y: 0)
            positionX += distanceOfCellsCenter
        }
    }

    func addCells(_ cells: [SKSpriteNode]) {
        self.cellCount += cells.count

        let distanceOfCellsCenter = self.cellWidth + self.cellSpacing
        let endCellOffset = distanceOfCellsCenter * Double((self.cellCount - 1) / 2)

        var positionX = -endCellOffset

        for index in 0..<self.cellCount {
            let cell = cells[index]
            cell.position = CGPoint(x: positionX, y: 0)
            self.addChild(cell)
            positionX += distanceOfCellsCenter
        }
    }

}

extension Inventory: InventoryProtocol {
    
    func isValid(_ coord: InventoryCoordinate) -> Bool {
        guard 0 <= coord.index && coord.index < self.cellCount else {
            return false
        }

        return self.children[coord.index].children.first == nil
    }

    func contains(_ item: GameObject) -> Bool {
        return self.isValid(item.invCoord!)
    }

    func item(at coord: InventoryCoordinate) -> GameObject? {
        let cell = self.children[coord.index]

        return cell.children.first as! GameObject?
    }

    func itemAtLocation(of touch: UITouch) -> GameObject? {
        for cell in self.children {
            if let go = cell.children.first as! GameObject?, go.isAtLocation(of: touch) {
                    return go
            }
        }
        return nil
    }

    func add(_ item: GameObject) {
        self.children[item.invCoord!.index].addChild(item)
        item.position = CGPoint()
    }

    func makeIterator() -> some IteratorProtocol {
        return self.children.makeIterator()
    }
}
