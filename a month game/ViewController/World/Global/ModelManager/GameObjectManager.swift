//
//  GameObjectManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/02.
//

import Foundation
import SpriteKit

class GameObjectManager {

    private static var _default: GameObjectManager?
    static var `default`: GameObjectManager { self._default! }

    static func set(scene: WorldScene,
                    ui: SKNode,
                    invInv: GameObjectInventory,
                    fieldInv: GameObjectInventory,
                    character: Character,
                    chunkContainer: ChunkContainer,
                    invContainer: InventoryContainer,
                    accessibleGOTracker: AccessibleGOTracker) {
        self._default = GameObjectManager(
            scene: scene,
            ui: ui,
            invInv: invInv,
            fieldInv: fieldInv,
            character: character,
            chunkContainer: chunkContainer,
            invContainer: invContainer,
            accessibleGOTracker: accessibleGOTracker)
    }

    static func free() { self._default = nil }

    let goInteractionHandlerManager: GameObjectInteractionHandlerManager

    let scene: WorldScene
    let character: Character
    let chunkContainer: ChunkContainer
    let invContainer: InventoryContainer
    let accessibleGOTracker: AccessibleGOTracker

    init(scene: WorldScene,
         ui: SKNode,
         invInv: GameObjectInventory,
         fieldInv: GameObjectInventory,
         character: Character,
         chunkContainer: ChunkContainer,
         invContainer: InventoryContainer,
         accessibleGOTracker: AccessibleGOTracker) {
        self.goInteractionHandlerManager = GameObjectInteractionHandlerManager(
            ui: ui,
            invInv: invInv,
            fieldInv: fieldInv,
            invContainer: invContainer,
            chunkContainer: chunkContainer)


        self.scene = scene
        self.character = character
        self.chunkContainer = chunkContainer
        self.invContainer = invContainer
        self.accessibleGOTracker = accessibleGOTracker
    }

    func take(_ go: GameObject) {
        guard let invCoord = self.invContainer.emptyCoord else {
            return
        }

        self.accessibleGOTracker.remove(go)

        self.removeFromParent(go)
        go.set(coord: invCoord)
        self.addToBelongInv(go)
    }

    func interact(_ go: GameObject) {
        guard let handler = self.goInteractionHandlerManager.goHandler[go.type] else {
            return
        }

        handler(self.goInteractionHandlerManager, go)
    }

    func interactToGO(_ go: GameObject, to targetGO: GameObject) {
        if targetGO.type.isTile,
           let targetCoord = targetGO.chunkCoord {
            self.removeFromParent(go)
            go.set(coord: targetCoord)
            self.addToBelongField(go)

            return
        }

        guard let handler = self.goInteractionHandlerManager.goToGOHandler[targetGO.type] else {
            return
        }

        handler(self.goInteractionHandlerManager, go, targetGO)
    }

    func new(type goType: GameObjectType,
             variant: Int = 0,
             count: Int = 1,
             chunkCoord: ChunkCoordinate) {
        for _ in 0 ..< count {
            let go = GameObject(type: goType, variant: variant, coord: chunkCoord)
            self.addToBelongField(go)
        }
    }

    func new(type goType: GameObjectType, variant: Int = 0, invCoord: InventoryCoordinate) {
        let go = GameObject(type: goType, variant: variant, coord: invCoord)
        self.addToBelongInv(go)

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func addToBelongField(_ go: GameObject) {
        let characterCoord = self.character.chunkCoord.coord

        self.chunkContainer.add(go)

        if !go.type.isWalkable
            && go.chunkCoord!.coord.isAdjacent(to: characterCoord) {
            self.accessibleGOTracker.add(go)
        }
    }

    func addToBelongInv(_ go: GameObject) {
        self.invContainer.add(go)
    }

    func move(_ go: GameObject, to chunkCoord: ChunkCoordinate) {
        self.removeFromParent(go)
        go.set(coord: chunkCoord)
        self.addToBelongField(go)
    }

    func move(_ go: GameObject, to invCoord: InventoryCoordinate) {
        self.removeFromParent(go)
        go.set(coord: invCoord)
        self.addToBelongInv(go)
    }

    func removeFromParent(_ go: GameObject) {
        if let chunk = go.parent as? Chunk {
            chunk.remove(go)
            self.accessibleGOTracker.remove(go)
        } else if let inventory = go.parent?.parent as? Inventory {
            inventory.remove(go)
        }
    }

    func remove(_ go: GameObject) {
        self.removeFromParent(go)
        go.delete()
    }
}
