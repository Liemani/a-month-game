//
//  SceneLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/07.
//

import Foundation
import SpriteKit

class SceneLowLogic {

    let interactionLogic: InteractionLogic

    let scene: WorldScene
    let character: Character
    let invContainer: InventoryContainer
    let chunkContainer: ChunkContainer
    let accessibleGOTracker: AccessibleGOTracker
    let ui: SKNode

    init(scene: WorldScene,
         ui: SKNode,
         invInv: GameObjectInventory,
         fieldInv: GameObjectInventory,
         character: Character,
         invContainer: InventoryContainer,
         chunkContainer: ChunkContainer,
         accessibleGOTracker: AccessibleGOTracker) {
        self.interactionLogic = InteractionLogic(
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
        self.ui = ui
    }

    // MARK: logic
    func interact(_ go: GameObject) {
        guard let handler = self.interactionLogic.go[go.type] else {
            return
        }

        handler(self.interactionLogic, go)
    }

    func interactToGO(_ go: GameObject, to targetGO: GameObject) {
        if targetGO.type.isTile,
           let targetCoord = targetGO.chunkCoord {
            self.move(go, to: targetCoord)

            return
        }

        guard let handler = self.interactionLogic.goToGO[targetGO.type] else {
            return
        }

        handler(self.interactionLogic, go, targetGO)
    }

    func new(type goType: GameObjectType, variant: Int = 0, coord chunkCoord: ChunkCoordinate) {
        let go = GameObject(type: goType, variant: variant, coord: chunkCoord)
        self.addToBelongField(go)
    }

    func new(type goType: GameObjectType, variant: Int = 0, coord invCoord: InventoryCoordinate) {
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

        FrameCycleUpdateManager.default.update(with: .craftWindow)
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

            FrameCycleUpdateManager.default.update(with: .craftWindow)
        }
    }

    func remove(_ go: GameObject) {
        self.removeFromParent(go)
        go.delete()
    }

    func closeAnyInv(of id: Int) {
        if let inv = self.invContainer.inv(id: id) {
            inv.isHidden = true

            FrameCycleUpdateManager.default.update(with: .craftWindow)
        }
    }

    func closeInvInv() {
        self.invContainer.invInv.isHidden = true

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func closeFieldInv() {
        self.invContainer.fieldInv.isHidden = true

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func openInvInv(of go: GameObject) {
        self.invContainer.invInv.update(go)
        self.invContainer.invInv.isHidden = false
        self.invContainer.invInv.position =
        go.convert(CGPoint(), to: self.ui)
        + CGPoint(x: 0,
                  y: Constant.defaultWidth + Constant.invCellSpacing)

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func openFieldInv(of go: GameObject) {
        self.invContainer.fieldInv.update(go)
        self.invContainer.fieldInv.isHidden = false
        self.invContainer.fieldInv.position = go.positionInWorld
        + CGPoint(x: 0, y: Constant.defaultWidth + Constant.invCellSpacing)

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

}
