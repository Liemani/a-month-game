//
//  InventoryContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/25.
//

import Foundation
import SpriteKit

enum InventoryIndex: Int, CaseIterable {

    case characterInv
    case invInv
    case fieldInv

}

class InventoryContainer {

    var invs: [Inventory]

    var characterInv: CharacterInventory {
        return self.invs[InventoryIndex.characterInv] as! CharacterInventory
    }
    var leftGO: GameObject? { self.characterInv.leftGO }
    var rightGO: GameObject? { self.characterInv.rightGO }

    var invInv: GameObjectInventory {
        return self.invs[InventoryIndex.invInv] as! GameObjectInventory
    }

    var fieldInv: GameObjectInventory {
        return self.invs[InventoryIndex.fieldInv] as! GameObjectInventory
    }

    init() {
        self.invs = []
        self.invs.reserveCapacity(InventoryIndex.allCases.count)

        let characterInv = CharacterInventory(id: 0)
        self.invs.append(characterInv)

        let invInv = GameObjectInventory(cellWidth: Constant.defaultWidth,
                                         cellSpacing: Constant.invCellSpacing)
        invInv.isHidden = true
        self.invs.append(invInv)

        let fieldInv = GameObjectInventory(cellWidth: Constant.defaultWidth,
                                           cellSpacing: Constant.invCellSpacing)
        fieldInv.isHidden = true
        self.invs.append(fieldInv)
    }

    func inv(id: Int) -> Inventory? {
        for inv in self.invs {
            if !inv.isHidden && inv.id == id {
                return inv
            }
        }

        return nil
    }

    var emptyCoord: InventoryCoordinate? {
        for inv in self.invs {
            if !inv.isHidden, let emptyCoord = inv.emptyCoord {
                return InventoryCoordinate(inv.id!, emptyCoord)
            }
        }

        return nil
    }

    func `is`(equiping goType: GameObjectType) -> Bool {
        return self.leftGO?.type == goType || self.rightGO?.type == goType
    }

    var space: Int {
        var space = 0

        for inv in self.invs {
            if !inv.isHidden {
                space += inv.space
            }
        }

        return space
    }

}

extension InventoryContainer: InventoryProtocol {

    func isValid(_ coord: InventoryCoordinate) -> Bool {
        for inv in self.invs {
            if !inv.isHidden && inv.isValid(coord.index){
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
        for inv in self.invs {
            if !inv.isHidden,
               let gos = inv.items(at: coord.index) {
                return gos
            }
        }

        return nil
    }

    func itemsAtLocation(of touch: UITouch) -> [GameObject]? {
        for inv in self.invs {
            if !inv.isHidden,
               let gos = inv.itemsAtLocation(of: touch) {
                return gos
            }
        }

        return nil
    }

    func coordAtLocation(of touch: UITouch) -> InventoryCoordinate? {
        for inv in self.invs {
            if !inv.isHidden,
               let index = inv.coordAtLocation(of: touch) {
                return InventoryCoordinate(inv.id!, index)
            }
        }

        return nil
    }

    func add(_ item: GameObject) {
        let invCoord = item.invCoord!

        for inv in self.invs {
            if !inv.isHidden && inv.id == invCoord.id {
                inv.add(item)

                return
            }
        }
    }

    func remove(_ item: GameObject) {
        let invID = item.invCoord!.id
        for inv in self.invs {
            if !inv.isHidden && invID == inv.id {
                inv.remove(item)

                return
            }
        }
    }

    func makeIterator() -> CombineSequences<GameObject> {
        let sequences = self.invs.compactMap { !$0.isHidden ? $0 : nil }
        return CombineSequences(sequences: sequences)
    }

}
