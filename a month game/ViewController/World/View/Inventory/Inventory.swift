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

    associatedtype Coord
    associatedtype Item
    associatedtype Items: Sequence<Item>

    func isValid(_ coord: Coord) -> Bool

    func items(at coord: Coord) -> Items?

    func itemsAtLocation(of touch: UITouch) -> Items?
    func coordAtLocation(of touch: UITouch) -> Coord?

    func add(_ item: Item, to coord: Coord)
    func remove(_ item: Item, from coord: Coord)

}

class Inventory: SKSpriteNode {

    var data: InventoryData

    var id: Int? { self.data.id }

    var capacity: Int { self.data.capacity }
    var count: Int { self.data.count }
    var space: Int { self.data.space }

    let cellWidth: Double
    let cellSpacing: Double

    var cells: [InventoryCell] { self.children as! [InventoryCell] }

    init(id: Int,
         cells: [InventoryCell],
         cellWidth: Double,
         cellSpacing: Double) {
        self.data = InventoryData(id: id, capacity: cells.count)

        self.cellWidth = cellWidth
        self.cellSpacing = cellSpacing

        super.init(texture: nil, color: .white, size: CGSize())

        self.data.inv = self

        self.addCells(cells)
        self.synchronizeData()
    }

    init(cellWidth: Double,
         cellSpacing: Double) {
        self.data = InventoryData()

        self.cellWidth = cellWidth
        self.cellSpacing = cellSpacing

        super.init(texture: nil, color: .white, size: CGSize())

        self.data.inv = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(cellCount: Int) {
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

        self.data.capacity = cellCount

        self.setCellPosition()
    }

    func synchronizeData() {
        self.clear()

        for goData in self.data {
            let go = GameObject(from: goData)
            self.add(go, to: go.invCoord!.index)
        }
    }

    func update(id: Int) {
        self.clear()

        self.data.update(id: id)

        for goData in self.data {
            let go = GameObject(from: goData)
            let index = go.invCoord!.index
            if self.isValid(index) {
                self.add(go, to: go.invCoord!.index)
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

    typealias Item = GameObject
    typealias Items = [Item]
    typealias Coord = Int

    func isValid(_ coord: Int) -> Bool {
        return 0 <= coord && coord < self.capacity
    }

    /// - Parameters:
    ///     - coord: suppose is valid
    func items(at coord: Int) -> [GameObject]? {
        let cell = self.children[coord]

        if !cell.children.isEmpty {
            return cell.children as! [GameObject]?
        } else {
            return nil
        }
    }

    func itemsAtLocation(of touch: UITouch) -> [GameObject]? {
        for cell in self.children {
            if cell.isBeing(touched: touch) {
                if !cell.children.isEmpty {
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

    func add(_ item: GameObject, to index: Int) {
        item.position = CGPoint()
        self.children[index].addChild(item)

        self.data.add(item.data)
    }

    func remove(_ item: GameObject, from index: Int) {
        item.removeFromParent()

        self.data.remove(item.data)
    }

    func makeIterator() -> some IteratorProtocol<GameObject> {
        return InventoryIterator(self)
    }

}

class InventoryIterator: IteratorProtocol {

    var iterator: any IteratorProtocol<GameObjectData>

    init(_ inv: Inventory) {
        self.iterator = inv.data.makeIterator()
    }

    func next() -> GameObject? {
        return self.iterator.next()?.go
    }

}

extension InventoryCell: TouchResponder {

    func isRespondable(with type: TouchRecognizer.Type) -> Bool {
        switch type {
        case is TapRecognizer.Type:
            return true
        default:
            return false
        }
    }

}
