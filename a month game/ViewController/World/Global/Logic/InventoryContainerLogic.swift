//
//  InventoryContainerLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/07.
//

import Foundation

class InventoryContainerLogic {

    private let invContainer: InventoryContainer

    init(invContainer: InventoryContainer) {
        self.invContainer = invContainer
    }

    var space: Int { self.invContainer.space }
    func space(of id: Int) -> Int? {
        return self.inv(id: id)?.space
    }

    var characterInv: CharacterInventory { self.invContainer.characterInv }
    var invInv: GameObjectInventory { self.invContainer.invInv }
    var fieldInv: GameObjectInventory { self.invContainer.fieldInv }

    func `is`(equiping goType: GameObjectType) -> Bool {
        return self.invContainer.is(equiping: goType)
    }

    func go(equiping goType: GameObjectType) -> GameObject? {
        self.invContainer.go(equiping: goType)
    }

    func invData(id: Int, capacity: Int) -> InventoryData {
        if let inv = Logics.default.invContainer.inv(id: id) {
            return inv.data
        } else {
            return InventoryData(id: id, capacity: capacity)
        }
    }

    func inv(id: Int) -> Inventory? {
        self.invContainer.inv(id: id)
    }

    var emptyCoord: InventoryCoordinate? {
        return self.invContainer.emptyCoord
    }

    func add(_ go: GameObject) {
        self.invContainer.add(go)

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func closeAnyInv(of id: Int) {
        if let inv = self.invContainer.inv(id: id) {
            inv.isHidden = true

            FrameCycleUpdateManager.default.update(with: .craftWindow)
        }
    }

    func openInvInv(of go: GameObject) {
        self.invContainer.invInv.reveal(with: go)
        self.invContainer.invInv.position =
            go.convert(CGPoint(), to: self.invContainer.characterInv.parent!)
            + CGPoint(x: 0, y: Constant.defaultWidth + Constant.invCellSpacing)

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func openFieldInv(of go: GameObject) {
        let chunk = go.parent as! Chunk
        let fieldInv = self.invContainer.fieldInv

        fieldInv.reveal(with: go)
        fieldInv.position = go.position
            + CGPoint(x: 0, y: Constant.defaultWidth + Constant.invCellSpacing)

        fieldInv.removeFromParent()
        chunk.addChild(fieldInv)

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func closeInvInv() {
        self.invContainer.invInv.hide()

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func closeFieldInv() {
        self.invContainer.fieldInv.hide()

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

}
