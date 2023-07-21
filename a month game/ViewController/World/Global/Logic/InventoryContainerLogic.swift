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

    var invInvGO: GameObject?
    var fieldInvGO: GameObject?

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
        self.invContainer.add(go, to: go.invCoord!)

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func closeAnyInv(of id: Int) {
        if let inv = self.invContainer.inv(id: id) {
            inv.isHidden = true

            FrameCycleUpdateManager.default.update(with: .craftWindow)
        }
    }

    func openInvInv(of go: GameObject) {
        self.invInvGO = go

        self.invContainer.invInv.reveal(with: go)
        self.invContainer.invInv.position =
            go.convert(CGPoint(), to: self.invContainer.characterInv.parent!)
            + CGPoint(x: 0, y: Constant.defaultWidth + Constant.defaultPadding)

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func openFieldInv(of go: GameObject) {
        self.fieldInvGO = go

        let chunkContainer = go.parent!.parent as! ChunkContainer

        self.fieldInv.reveal(with: go)
        self.moveFieldInvToGO()

        self.fieldInv.removeFromParent()
        chunkContainer.addChild(self.fieldInv)

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func moveFieldInvToGO() {
        guard !self.fieldInv.isHidden else { return }

        let go = self.fieldInvGO!

        if go.isDeleted {
            self.closeFieldInv()
            return
        }

        let middleCoordInWorld = Services.default.character.chunkCoord.chunk.coord
        let coordInWorld = go.chunkCoord!.coord - middleCoordInWorld
        let goPosition = CoordinateConverter(coordInWorld).fieldPoint

        self.fieldInv.position = goPosition
            + CGPoint(x: 0, y: Constant.defaultWidth + Constant.defaultPadding)
    }

    func closeInvInv() {
        self.invContainer.invInv.hide()
        self.invInvGO = nil

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func closeFieldInv() {
        self.invContainer.fieldInv.hide()
        self.fieldInvGO = nil

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func isEmpty(_ id: Int) -> Bool {
        if let sourceInvData = Logics.default.invContainer.inv(id: id)?.data {
            return sourceInvData.isEmpty
        } else {
            let goDatas = Services.default.inv.load(id: id)
            return goDatas.isEmpty
        }
    }

    func deleteAll(_ id: Int) {
        if let sourceInvData = Logics.default.invContainer.inv(id: id)?.data {
            for goData in sourceInvData {
                goData.delete()
                sourceInvData.remove(goData)
            }

            sourceInvData.inv!.synchronizeData()
        } else {
            let goDatas = Services.default.inv.load(id: id)
            for goData in goDatas {
                goData.delete()
            }
        }
    }

}
