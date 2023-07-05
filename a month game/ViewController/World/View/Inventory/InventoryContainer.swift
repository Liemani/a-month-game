//
//  InventoryContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/25.
//

import Foundation
import SpriteKit

class InventoryContainer {

    let characterInv: CharacterInventory

    var fieldInv: Inventory?
    var invInv: Inventory?

    var leftGO: GameObject? { self.characterInv.leftGO }
    var rightGO: GameObject? { self.characterInv.rightGO }

    init() {
        self.characterInv = CharacterInventory(id: 0)
    }

    var emptyCoord: InventoryCoordinate? {
        if let emptyCoord = self.characterInv.emptyCoord {
            return InventoryCoordinate(self.characterInv.id, emptyCoord)
        }

        if let emptyCoord = self.invInv?.emptyCoord {
            return InventoryCoordinate(self.invInv!.id, emptyCoord)
        }

        if let emptyCoord = self.fieldInv?.emptyCoord {
            return InventoryCoordinate(self.fieldInv!.id, emptyCoord)
        }

        return nil
    }

    func `is`(equiping goType: GameObjectType) -> Bool {
        return self.leftGO?.type == goType || self.rightGO?.type == goType
    }

}

extension InventoryContainer: InventoryProtocol {

    func isValid(_ coord: InventoryCoordinate) -> Bool {
        if self.characterInv.isValid(coord.index) {
            return true
        }

        if let fieldInv = self.fieldInv {
            if fieldInv.isValid(coord.index) {
                return true
            }
        }

        if let invInv = self.invInv {
            if invInv.isValid(coord.index) {
                return true
            }
        }

        return false
    }

    func contains(_ item: GameObject) -> Bool {
        guard let invCoord = item.invCoord else {
            return false
        }

        return self.isValid(invCoord)
    }

    func items(at coord: InventoryCoordinate) -> [GameObject]? {
        if let gos = self.characterInv.items(at: coord.index) {
            return gos
        }

        if let gos = self.fieldInv?.items(at: coord.index) {
            return gos
        }

        if let gos = self.invInv?.items(at: coord.index) {
            return gos
        }

        return nil
    }

    func itemsAtLocation(of touch: UITouch) -> [GameObject]? {
        if let gos = self.characterInv.itemsAtLocation(of: touch) {
            return gos
        }

        if let gos = self.fieldInv?.itemsAtLocation(of: touch) {
            return gos
        }

        if let gos = self.invInv?.itemsAtLocation(of: touch) {
            return gos
        }

        return nil
    }

    func coordAtLocation(of touch: UITouch) -> InventoryCoordinate? {
        if let index = self.characterInv.coordAtLocation(of: touch) {
            return InventoryCoordinate(self.characterInv.id, index)
        }

        if let index = self.fieldInv?.coordAtLocation(of: touch) {
            return InventoryCoordinate(self.fieldInv!.id, index)
        }

        if let index = self.invInv?.coordAtLocation(of: touch) {
            return InventoryCoordinate(self.invInv!.id, index)
        }

        return nil
    }

    func add(_ item: GameObject) {
        if self.characterInv.items(at: item.invCoord!.index) == nil {
            self.characterInv.add(item)

            return
        }

        if let fieldInv = self.fieldInv,
           fieldInv.items(at: item.invCoord!.index) == nil {
            self.fieldInv!.add(item)

            return
        }

        if let invInv = self.invInv ,
           invInv.items(at: item.invCoord!.index) == nil {
            self.invInv!.add(item)

            return
        }
    }

    func remove(_ item: GameObject) {
        if item.invCoord!.id == self.characterInv.id {
            self.characterInv.remove(item)

            return
        }

        if let fieldInv = self.fieldInv,
           item.invCoord!.id == fieldInv.id {
            fieldInv.remove(item)

            return
        }

        if let invInv = self.invInv,
           item.invCoord!.id == invInv.id {
            invInv.remove(item)

            return
        }
    }

    func makeIterator() -> CombineSequences<GameObject> {
        let sequences = [
            self.characterInv,
            self.fieldInv,
            self.invInv,
        ]
            .compactMap { $0 }

        return CombineSequences(sequences: sequences)
    }

}
