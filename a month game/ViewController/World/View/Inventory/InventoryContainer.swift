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

}

extension InventoryContainer: InventoryProtocol {

    func isValid(_ coord: InventoryCoordinate) -> Bool {
        if self.characterInv.isValid(coord) {
            return true
        }

        if let fieldInv = self.fieldInv {
            if fieldInv.isValid(coord) {
                return true
            }
        }

        if let invInv = self.invInv {
            if invInv.isValid(coord) {
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
        if let go = self.characterInv.item(at: coord) {
            return go
        }

        if let go = self.fieldInv?.item(at: coord) {
            return go
        }

        if let go = self.invInv?.item(at: coord) {
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

    func add(_ item: GameObject) {
        if self.characterInv.item(at: item.invCoord!) == nil {
            self.characterInv.add(item)
        }

        if self.fieldInv?.item(at: item.invCoord!) == nil {
            self.fieldInv!.add(item)
        }

        if self.invInv?.item(at: item.invCoord!) == nil {
            self.invInv!.add(item)
        }
    }

    func makeIterator() -> some IteratorProtocol {
        var sequences: [Inventory] = [self.characterInv]

        if let fieldInv = self.fieldInv {
            sequences.append(fieldInv)
        }

        if let invInv = self.invInv {
            sequences.append(invInv)
        }

        return CombineSequences(sequences: sequences)
    }

}
