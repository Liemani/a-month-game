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

    static func set(character: Character,
                    chunkContainer: ChunkContainer,
                    invContainer: InventoryContainer,
                    accessibleGOTracker: AccessibleGOTracker) {
        self._default = GameObjectManager(character: character,
                                          chunkContainer: chunkContainer,
                                          invContainer: invContainer,
                                          accessibleGOTracker: accessibleGOTracker)
    }

    static func free() { self._default = nil }

    let character: Character
    let chunkContainer: ChunkContainer
    let invContainer: InventoryContainer
    let accessibleGOTracker: AccessibleGOTracker

    init(character: Character,
         chunkContainer: ChunkContainer,
         invContainer: InventoryContainer,
         accessibleGOTracker: AccessibleGOTracker) {
        self.character = character
        self.chunkContainer = chunkContainer
        self.invContainer = invContainer
        self.accessibleGOTracker = accessibleGOTracker
    }

    func moveToBelongField(_ go: GameObject) {
        let characterCoord = self.character.data.chunkCoord.coord

        self.removeFromParent(go)
        self.chunkContainer.add(go)

        if go.type.walkSpeed == -1.0
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
        go.data.set(coord: invCoord)
        self.moveToBelongInv(go)
    }

    func interact(_ go: GameObject) {
        print("interact go")
    }

    func interactToGO(_ go: GameObject, to targetGO: GameObject) {
        if targetGO.type == .woodFloorTile,
           let targetCoord = targetGO.chunkCoord {
            go.data.set(coord: targetCoord)
            self.moveToBelongField(go)

            return
        }
    }

    func removeFromParent(_ go: GameObject) {
        if let chunk = go.parent as? Chunk {
            chunk.data.remove(go)
            self.accessibleGOTracker.remove(go)
        } else if go.parent?.parent is Inventory {
            if let activatedGO = TouchHandlerContainer.default.activatedGO,
               go == activatedGO {
                TouchHandlerContainer.default.activatedGO = nil
            }

            FrameCycleUpdateManager.default.update(with: .craftWindow)
        }

        go.removeFromParent()
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
