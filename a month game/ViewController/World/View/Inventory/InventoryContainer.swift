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
                                         cellSpacing: Constant.defaultPadding)
        invInv.isHidden = true
        self.invs.append(invInv)

        let fieldInv = GameObjectInventory(cellWidth: Constant.defaultWidth,
                                           cellSpacing: Constant.defaultPadding)
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

    func go(equiping goType: GameObjectType) -> GameObject? {
        if self.rightGO?.type == goType {
            return self.rightGO
        }

        if self.leftGO?.type == goType {
            return self.leftGO
        }

        return nil
    }

    func go(equiping goTypes: [GameObjectType]) -> GameObject? {
        if let rightGO = self.rightGO {
            let rightGOType = rightGO.type

            for goType in goTypes {
                if goType == rightGOType {
                    return rightGO
                }
            }
        }

        if let leftGO = self.leftGO {
            let leftGOType = leftGO.type

            for goType in goTypes {
                if goType == leftGOType {
                    return leftGO
                }
            }
        }

        return nil
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

    typealias Coord = InventoryCoordinate
    typealias Item = GameObject
    typealias Items = [Item]

    func isValid(_ coord: InventoryCoordinate) -> Bool {
        for inv in self.invs {
            if !inv.isHidden && inv.isValid(coord.index){
                return true
            }
        }

        return false
    }

    func items(at coord: InventoryCoordinate) -> [GameObject]? {
        for inv in self.invs {
            if !inv.isHidden {
                return inv.items(at: coord.index)
            }
        }

        return nil
    }

    func itemsAtLocation(of touch: UITouch) -> [GameObject]? {
        for inv in self.invs {
            if !inv.isHidden {
                return inv.itemsAtLocation(of: touch)
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

    func add(_ item: GameObject, to coord: Coord) {
        for inv in self.invs {
            if !inv.isHidden && inv.id == coord.id {
                inv.add(item, to: coord.index)

                return
            }
        }
    }

    func remove(_ item: GameObject, from coord: Coord) {
        for inv in self.invs {
            if !inv.isHidden && inv.id == coord.id {
                inv.remove(item, from: coord.index)

                return
            }
        }
    }

    func makeIterator() -> CombineSequences<GameObject> {
        let sequences = self.invs.compactMap { !$0.isHidden ? $0 : nil }
        return CombineSequences(sequences: sequences)
    }

}
