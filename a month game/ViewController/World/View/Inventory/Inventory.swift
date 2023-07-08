//
//  Container.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

class InventoryCell: SKSpriteNode {

    var go: GameObject? { self.children.first as! GameObject? }

    func activate() {
        self.alpha = 0.5
    }

    func deactivate() {
        self.alpha = 1.0
    }

    var invCoord: InventoryCoordinate {
        let inventory = self.parent as! Inventory
        let index = inventory.coordAtLocation(of: self)!
        return InventoryCoordinate(inventory.id!, index)
    }

    var isEmpty: Bool { self.children.isEmpty }

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
    func remove(_ item: Item)

}

class Inventory: SKSpriteNode {

    var data: InventoryData

    var id: Int? { self.data.id }
    var capacity: Int
    var count: Int { self.data.count }
    var space: Int { self.capacity - self.count }

    let cellWidth: Double
    let cellSpacing: Double

    var cells: [InventoryCell] { self.children as! [InventoryCell] }

    init(id: Int? = nil,
         texture: SKTexture? = nil,
         cells: [InventoryCell]? = nil,
         cellWidth: Double,
         cellSpacing: Double) {
        self.data = InventoryData()

        self.capacity = cells?.count ?? 0

        self.cellWidth = cellWidth
        self.cellSpacing = cellSpacing

        super.init(texture: texture, color: .white, size: texture?.size() ?? CGSize())

        if let cells = cells {
            self.addCells(cells)
        }

        if let id = id {
            self.update(id: id)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(cellCount: Int) {
        guard self.capacity != cellCount else {
            return
        }

        if self.capacity > cellCount {
            let removeCount = self.capacity - cellCount

            let cells = self.cells
            for index in 0 ..< removeCount {
                cells[index].removeFromParent()
            }
        } else if self.capacity < cellCount {
            let addCount = cellCount - self.capacity

            let cellTexture = SKTexture(imageNamed: Constant.ResourceName.inventoryCell)

            for _ in 0 ..< addCount {
                let cell = InventoryCell(texture: cellTexture)
                cell.size = Constant.defaultNodeSize
                self.addChild(cell)
            }
        }

        self.capacity = cellCount

        self.setCellPosition()
    }

    func update(id: Int) {
        self.clear()

        self.data.update(id: id)

        for goData in self.data {
            let go = GameObject(from: goData)
            let index = go.invCoord!.index
            if self.isValid(index) {
                self.add(go)
            }
        }
    }

    private func clear() {
        for cell in self.cells {
            if let go = cell.children.first {
                go.removeFromParent()
            }
        }
    }

    private func addCells(_ cells: [InventoryCell]) {
        for cell in cells {
            self.addChild(cell)
        }

        self.setCellPosition()
    }

    private func setCellPosition() {
        let distanceOfCellsCenter = self.cellWidth + self.cellSpacing
        let endCellOffset = distanceOfCellsCenter * Double(self.capacity - 1) / 2.0

        var positionX = -endCellOffset

        for cell in self.cells {
            cell.position = CGPoint(x: positionX, y: 0)
            positionX += distanceOfCellsCenter
        }
    }

    var emptyCoord: Int? {
        for (index, cell) in self.cells.enumerated() {
            if cell.isEmpty {
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
        return 0 <= coord && coord < self.capacity
    }

    func contains(_ item: GameObject) -> Bool {
        return item.invCoord!.id == self.id
    }

    func items(at coord: Int) -> [GameObject]? {
        guard !self.isValid(coord) else {
            return nil
        }

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
        item.position = CGPoint()
        self.children[item.invCoord!.index].addChild(item)

        self.data.add(item.data)
    }

    func remove(_ item: GameObject) {
        item.removeFromParent()

        self.data.remove(item.data)
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

            if index == self.inv.capacity {
                return nil
            }

            self.goIterator = self.inv.items(at: index)?.makeIterator()
        }
    }

}

// MARK: - touch responder
extension InventoryCell: TouchResponder {

    func touchBegan(_ touch: UITouch) {
        let invTouchLogic = InventoryTouchLogic(touch: touch, cell: self)
        LogicContainer.default.touch.add(invTouchLogic)
        invTouchLogic.began()
    }

    func touchMoved(_ touch: UITouch) {
        LogicContainer.default.touch.moved(touch)
    }

    func touchEnded(_ touch: UITouch) {
        LogicContainer.default.touch.ended(touch)
    }

    func touchCancelled(_ touch: UITouch) {
        LogicContainer.default.touch.cancelled(touch)
    }

}
