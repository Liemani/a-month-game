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

    var characterInv: CharacterInventory { self.invContainer.characterInv }
    var invInv: GameObjectInventory { self.invContainer.invInv }
    var fieldInv: GameObjectInventory { self.invContainer.fieldInv }

    func `is`(equiping goType: GameObjectType) -> Bool {
        return self.invContainer.is(equiping: goType)
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
        self.invContainer.invInv.update(go)
        self.invContainer.invInv.isHidden = false
        self.invContainer.invInv.position =
        go.convert(CGPoint(), to: self.invContainer.characterInv.parent!)
            + CGPoint(x: 0, y: Constant.defaultWidth + Constant.invCellSpacing)

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func openFieldInv(of go: GameObject) {
        let chunk = go.parent as! Chunk
        let fieldInv = self.invContainer.fieldInv

        fieldInv.update(go)
        fieldInv.isHidden = false
        fieldInv.position = go.position
            + CGPoint(x: 0, y: Constant.defaultWidth + Constant.invCellSpacing)

        fieldInv.removeFromParent()
        chunk.addChild(fieldInv)

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func closeInvInv() {
        self.invContainer.invInv.isHidden = true

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func closeFieldInv() {
        self.invContainer.fieldInv.isHidden = true

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

}
