//
//  SceneLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/07.
//

import Foundation
import SpriteKit

class SceneLogic {

    // MARK: - game object
    func new(type goType: GameObjectType,
             variant: Int = 0,
             count: Int = 1,
             coord chunkCoord: ChunkCoordinate) {
        for _ in 0 ..< count {
            LogicContainer.default.go.new(type: goType,
                                                variant: variant,
                                                coord: chunkCoord)
        }
    }

    func move(_ go: GameObject, to invCoord: InventoryCoordinate) {
        if !go.type.isInv {
            LogicContainer.default.go.move(go, to: invCoord)

            return
        }

        guard invCoord.id == Constant.characterInventoryID
                || ServiceContainer.default.invServ.isEmpty(id: go.id) else {
            return
        }

        LogicContainer.default.go.move(go, to: invCoord)

        LogicContainer.default.invContainer.closeAnyInv(of: go.id)
    }

    func move(_ go: GameObject, to chunkCoord: ChunkCoordinate) {
        LogicContainer.default.go.move(go, to: chunkCoord)

        if go.type.isInv {
            LogicContainer.default.invContainer.closeAnyInv(of: go.id)
        }
    }

    // MARK: - inventory
    func containerInteract(_ container: GameObject) {
        let invInv = LogicContainer.default.invContainer.invInv
        let fieldInv = LogicContainer.default.invContainer.fieldInv

        if container.id == invInv.id && !invInv.isHidden {
            LogicContainer.default.invContainer.closeInvInv()

            return
        }

        if container.id == fieldInv.id && !fieldInv.isHidden {
            LogicContainer.default.invContainer.closeFieldInv()

            return
        }

        if let invCoord = container.invCoord,
           invCoord.id != Constant.characterInventoryID {
            return
        }

        if container.isOnField {
            LogicContainer.default.invContainer.openFieldInv(of: container)
        } else {
            LogicContainer.default.invContainer.openInvInv(of: container)
        }
    }

    func gameObjectInteractContainer(_ go: GameObject, to container: GameObject) {
        var index: Int = 0

        if let inv = LogicContainer.default.invContainer.inv(id: container.id) {
            if let emptyIndex = inv.emptyCoord {
                index = emptyIndex
            } else {
                return
            }
        } else {
            index = ServiceContainer.default.invServ.emptyIndex(id: container.id)

            guard index < container.type.invCapacity else {
                return
            }
        }

        let invCoord = InventoryCoordinate(container.id, index)
        LogicContainer.default.scene.move(go, to: invCoord)
    }

    func containerTransfer(_ source: GameObject, to dest: GameObject) {
        let sourceInvData = LogicContainer.default.invContainer.invData(
            id: source.id,
            capacity: source.type.invCapacity)

        let destInvData = LogicContainer.default.invContainer.invData(
            id: dest.id,
            capacity: dest.type.invCapacity)

        let transferCount = min(sourceInvData.count, destInvData.space)

        var count = 0

        for goData in sourceInvData {
            if count == transferCount {
                break
            }

            LogicContainer.default.go.move(goData, to: destInvData)

            count += 1
        }

        if let sourceInv = sourceInvData.inv {
            sourceInv.synchronizeData()
        }

        if let destInv = destInvData.inv {
            destInv.synchronizeData()
        }
    }

    // MARK: - chunk
    func chunkContainerUpdate(direction: Direction4) {
        LogicContainer.default.chunkContainer.chunkContainerUpdate(direction: direction)

        let fieldInv = LogicContainer.default.invContainer.fieldInv
        if fieldInv.parent == nil {
            LogicContainer.default.invContainer.closeFieldInv()
        }
    }

}
