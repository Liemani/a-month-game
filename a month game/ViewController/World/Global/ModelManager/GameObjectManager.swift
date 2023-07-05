//
//  GameObjectManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/02.
//

import Foundation

class GameObjectManager {

    private static var _default: GameObjectManager?
    static var `default`: GameObjectManager { self._default! }

    static func set(scene: WorldScene,
                    character: Character,
                    chunkContainer: ChunkContainer,
                    invContainer: InventoryContainer,
                    accessibleGOTracker: AccessibleGOTracker) {
        self._default = GameObjectManager(scene: scene,
                                          character: character,
                                          chunkContainer: chunkContainer,
                                          invContainer: invContainer,
                                          accessibleGOTracker: accessibleGOTracker)
    }

    static func free() { self._default = nil }

    let scene: WorldScene
    let character: Character
    let chunkContainer: ChunkContainer
    let invContainer: InventoryContainer
    let accessibleGOTracker: AccessibleGOTracker

    init(scene: WorldScene,
         character: Character,
         chunkContainer: ChunkContainer,
         invContainer: InventoryContainer,
         accessibleGOTracker: AccessibleGOTracker) {
        self.scene = scene
        self.character = character
        self.chunkContainer = chunkContainer
        self.invContainer = invContainer
        self.accessibleGOTracker = accessibleGOTracker
    }

    func moveToBelongField(_ go: GameObject) {
        let characterCoord = self.character.chunkCoord.coord

        self.removeFromParent(go)
        self.chunkContainer.add(go)

        if !go.type.isWalkable
            && go.chunkCoord!.coord.isAdjacent(to: characterCoord) {
            self.accessibleGOTracker.add(go)
        }
    }

    func moveToBelongInv(_ go: GameObject) {
        self.removeFromParent(go)
        self.invContainer.add(go)
    }

    func take(_ go: GameObject) {
        guard let invCoord = self.invContainer.emptyCoord else {
            return
        }

        self.accessibleGOTracker.remove(go)

        self.removeFromParent(go)
        go.set(coord: invCoord)
        self.moveToBelongInv(go)
    }

    func interact(_ go: GameObject) {
        GameObjectInteractionHandler.handler[go.type](self.scene, go)
    }

    func interactToGO(_ go: GameObject, to targetGO: GameObject) {
        if targetGO.type == .woodFloorTile,
           let targetCoord = targetGO.chunkCoord {
            go.set(coord: targetCoord)
            self.moveToBelongField(go)

            return
        }
    }

    func removeFromParent(_ go: GameObject) {
        if let chunk = go.parent as? Chunk {
            chunk.remove(go)
            self.accessibleGOTracker.remove(go)
        } else if let inventory = go.parent?.parent as? Inventory {
            inventory.remove(go)
        }
    }

    func new(type goType: GameObjectType, chunkCoord: ChunkCoordinate) {
        let go = GameObject(type: goType, coord: chunkCoord)
        self.moveToBelongField(go)
    }

    func new(type goType: GameObjectType, invCoord: InventoryCoordinate) {
        let go = GameObject(type: goType, coord: invCoord)
        self.moveToBelongInv(go)

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }
}
