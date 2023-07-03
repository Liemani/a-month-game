//
//  Container.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

class InventoryCell: SKSpriteNode {

    func activate() {
        self.alpha = 0.5
    }

    func deactivate() {
        self.alpha = 1.0
    }

    var invCoord: InventoryCoordinate {
        let inventory = self.parent as! Inventory
        let index = inventory.coordAtLocation(of: self)!
        return InventoryCoordinate(inventory.id, index)
    }

}

protocol InventoryProtocol<Item>: Sequence {

    associatedtype Item
    associatedtype Coord
    associatedtype Items

    func isValid(_ coord: Coord) -> Bool
    func contains(_ item: Item) -> Bool

    func items(at coord: Coord) -> Items?

    func itemsAtLocation(of touch: UITouch) -> Items?
    func coordAtLocation(of touch: UITouch) -> Coord?

    func add(_ item: Item)

}

class Inventory: SKSpriteNode {

    let id: Int

    var cellCount: Int
    let cellWidth: Double
    let cellSpacing: Double

    init(id: Int,
         texture: SKTexture,
         cells: [InventoryCell],
         cellWidth: Double,
         cellSpacing: Double) {
        self.id = id
        self.cellCount = 0
        self.cellWidth = cellWidth
        self.cellSpacing = cellSpacing

        super.init(texture: texture, color: .white, size: texture.size())

        self.addCells(cells)

        self.setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {
        let goDatas = WorldServiceContainer.default.invServ.load(id: self.id)

        for goData in goDatas {
            let go = GameObject(from: goData)
            let index = go.invCoord!.index
            if self.isValid(index) {
                self.add(go)
            }
        }
    }

    private func addCells(_ cells: [InventoryCell]) {
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

    var emptyCoord: Int? {
        for (index, cell) in self.children.enumerated() {
            if cell.children.first == nil {
                return index
            }
        }
        return nil
    }

    func coordAtLocation(of invCell: InventoryCell) -> Int? {
        for (index, cell) in self.children.enumerated() {
            if cell == invCell {
                return index
            }
        }
        return nil
    }

}

extension Inventory: InventoryProtocol {

    func isValid(_ coord: Int) -> Bool {
        return 0 <= coord && coord < self.cellCount
    }

    func contains(_ item: GameObject) -> Bool {
        return item.invCoord!.id == self.id
    }

    func items(at coord: Int) -> [GameObject]? {
        let cell = self.children[coord]

        if cell.children.count != 0 {
            return cell.children as! [GameObject]?
        } else {
            return nil
        }
    }

    func itemsAtLocation(of touch: UITouch) -> [GameObject]? {
        for cell in self.children {
            if cell.isBeing(touched: touch) {
                if cell.children.count != 0 {
                    return cell.children as! [GameObject]?
                } else {
                    return nil
                }
            }
        }

        return nil
    }

    func coordAtLocation(of touch: UITouch) -> Int? {
        for (index, cell) in self.children.enumerated() {
            if cell.isBeing(touched: touch) {
                return index
            }
        }
        return nil
    }

    func add(_ item: GameObject) {
        self.children[item.invCoord!.index].addChild(item)
        item.position = CGPoint()

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func makeIterator() -> some IteratorProtocol<GameObject> {
        return InventoryIterator(self)
    }

}

struct InventoryIterator: IteratorProtocol {

    let inv: Inventory
    var index: Int
    var goIterator: IndexingIterator<[GameObject]>?

    init(_ inv: Inventory) {
        self.inv = inv
        self.index = 0

        self.goIterator = self.inv.items(at: index)?.makeIterator()
    }

    mutating func next() -> GameObject? {
        while true {
            if let go = self.goIterator?.next() {
                return go
            }

            index += 1

            if index == self.inv.cellCount {
                return nil
            }

            self.goIterator = self.inv.items(at: index)?.makeIterator()
        }
    }

}

// MARK: - touch responder
extension InventoryCell: TouchResponder {

    func touchBegan(_ touch: UITouch) {
        TouchHandlerContainer.default.invTouchHandler.began(touch: touch,
                                                            touchedCell: self)
    }

    func touchMoved(_ touch: UITouch) {
        let handler = TouchHandlerContainer.default.invTouchHandler

        guard touch == handler.touch else {
            return
        }

        handler.moved()
    }

    func touchEnded(_ touch: UITouch) {
        let handler = TouchHandlerContainer.default.invTouchHandler

        guard touch == handler.touch else {
            return
        }

        handler.ended()
    }

    func touchCancelled(_ touch: UITouch) {
        let handler = TouchHandlerContainer.default.invTouchHandler

        guard touch == handler.touch else {
            return
        }

        handler.cancelled()
    }

}
