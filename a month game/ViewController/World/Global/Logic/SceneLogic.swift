//
//  SceneLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/07.
//

import Foundation
import SpriteKit

class SceneLogic {

    let scene: WorldScene

    init(scene: WorldScene) {
        self.scene = scene
    }

    var timeInterval: Double { self.scene.timeInterval }

    // MARK: - game object
    func new(result: TaskResultType,
             type goType: GameObjectType,
             variant: Int = 0,
             quality: Double = 0.0,
             state: GameObjectState = [],
             coord invCoord: InventoryCoordinate) {
        guard result != .fail else { return }

        let go = GameObject.new(type: goType,
                                variant: variant,
                                state: state,
                                coord: invCoord)
        go.setQuality(quality, by: result)
    }

    func new(result: TaskResultType,
             type goType: GameObjectType,
             variant: Int = 0,
             quality: Double = 0.0,
             state: GameObjectState = [],
             coord chunkCoord: ChunkCoordinate) {
        guard result != .fail else { return }

        let go = GameObject.new(type: goType,
                                variant: variant,
                                state: state,
                                coord: chunkCoord)
        go.setQuality(quality, by: result)
    }

    func new(result: TaskResultType,
             type goType: GameObjectType,
             variant: Int = 0,
             quality: Double = 0.0,
             state: GameObjectState = [],
             coord chunkCoord: ChunkCoordinate,
             count: Int) {
        for _ in 0 ..< count {
            Logics.default.scene.new(result: result,
                                     type: goType,
                                     variant: variant,
                                     quality: quality,
                                     state: state,
                                     coord: chunkCoord)
        }
    }

    // MARK: - inventory
    func containerInteract(_ container: GameObject) {
        let invInv = Logics.default.invContainer.invInv
        let fieldInv = Logics.default.invContainer.fieldInv

        if container.id == invInv.id && !invInv.isHidden {
            Logics.default.invContainer.closeInvInv()

            return
        }

        if container.id == fieldInv.id && !fieldInv.isHidden {
            Logics.default.invContainer.closeFieldInv()

            return
        }

        if let invCoord = container.invCoord,
           invCoord.id != Constant.characterInventoryID {
            return
        }

        if container.isOnField {
            Logics.default.invContainer.openFieldInv(of: container)
        } else {
            Logics.default.invContainer.openInvInv(of: container)
        }
    }

    func gameObjectInteractContainer(_ go: GameObject, to container: GameObject) {
        var index: Int = 0

        if let inv = Logics.default.invContainer.inv(id: container.id) {
            if let emptyIndex = inv.emptyCoord {
                index = emptyIndex
            } else {
                return
            }
        } else {
            index = Services.default.inv.emptyIndex(id: container.id)

            guard index < container.type.invCapacity else {
                return
            }
        }

        let invCoord = InventoryCoordinate(container.id, index)
        go.move(to: invCoord)
    }

    func containerTransfer(_ source: GameObject, to dest: GameObject) {
        let sourceInvData = Logics.default.invContainer.invData(
            id: source.id,
            capacity: source.type.invCapacity)

        let destInvData = Logics.default.invContainer.invData(
            id: dest.id,
            capacity: dest.type.invCapacity)

        let transferCount = min(sourceInvData.count, destInvData.space)

        var count = 0

        for goData in sourceInvData {
            if count == transferCount {
                break
            }

            Logics.default.goData.move(goData, to: destInvData)

            count += 1
        }

        if let sourceInv = sourceInvData.inv {
            sourceInv.synchronizeData()
        }

        if let destInv = destInvData.inv {
            destInv.synchronizeData()
        }
    }

    // MARK: - etc
    func isDescendantOfUILayer(_ node: SKNode) -> Bool {
        return node.isDescendant(self.scene.ui)
    }

    func escape() {
        Services.default.character.reset()
        Services.default.chunkContainer.reset()
    }

}
