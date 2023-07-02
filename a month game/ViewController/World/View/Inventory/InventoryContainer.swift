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

    func item(at coord: InventoryCoordinate) -> GameObject? {
        if let go = self.characterInv.item(at: coord.index) {
            return go
        }

        if let go = self.fieldInv?.item(at: coord.index) {
            return go
        }

        if let go = self.invInv?.item(at: coord.index) {
            return go
        }

        return nil
    }

    func itemAtLocation(of touch: UITouch) -> GameObject? {
        if let go = self.characterInv.itemAtLocation(of: touch) {
            return go
        }

        if let go = self.fieldInv?.itemAtLocation(of: touch) {
            return go
        }

        if let go = self.invInv?.itemAtLocation(of: touch) {
            return go
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
        if self.characterInv.item(at: item.invCoord!.index) == nil {
            self.characterInv.add(item)

            return
        }

        if let fieldInv = self.fieldInv,
           fieldInv.item(at: item.invCoord!.index) == nil {
            self.fieldInv!.add(item)

            return
        }

        if let invInv = self.invInv ,
           invInv.item(at: item.invCoord!.index) == nil {
            self.invInv!.add(item)

            return
        }
    }

    func makeIterator() -> some IteratorProtocol<GameObject> {
        let sequences = [
            self.characterInv,
            self.fieldInv,
            self.invInv,
        ]
            .compactMap { $0 }

        return CombineSequences(sequences: sequences)
    }

}
