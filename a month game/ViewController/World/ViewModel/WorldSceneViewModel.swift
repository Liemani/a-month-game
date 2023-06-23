//
//  WorldViewModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/19.
//

import Foundation
import SpriteKit

class WorldSceneViewModel {

    let movingLayer: MovingLayer

    var chunkContainer: ChunkContainer

    let characterInv: any Inventory

    var fieldInv: (any Inventory)?
    var characterInvInv: (any Inventory)?

    let character: Character

    var interactableGOTracker: AccessableGOTracker

    // MARK: - computed property
    var fieldGOs: some Sequence<GameObject> { self.chunkContainer.gos }

//    var interactableGOs: [GameObject] {
//        var interactableGOs = [GameObjectNode]()
//
//        for go in self.chunkContainer.gos {
//            let characterCoord = self.characterMoveTouchEventHandler.
//            if go.intersects(interactionZone) {
//                interactableGOs.append(child)
//            }
//        }
//        return interactableGOs
//    }

    // MARK: - init
    init(movingLayer: MovingLayer,
         chunkContainer: ChunkContainer,
         characterInv: any Inventory,
         fieldInv: (any Inventory)? = nil,
         characterInvInv: (any Inventory)? = nil,
         character: Character) {
        self.movingLayer = movingLayer
        self.chunkContainer = chunkContainer
        self.characterInv = characterInv
        self.fieldInv = fieldInv
        self.characterInvInv = characterInvInv
        self.character = character

        chunkContainer.setUp(chunkCoord: character.data.chunkCoord)

        self.interactableGOTracker = AccessableGOTracker()
        EventManager.default.shouldUpdate.update(with: .interaction)
    }

    // MARK: - update
    func update(_ timeInterval: TimeInterval) {
//        self.handleSceneEvent()

        self.updateCharacter(timeInterval)
        if EventManager.default.shouldUpdate.contains(.interaction) {
            self.interactableGOTracker.updateWhole(character: self.character,
                                                 gos: self.fieldGOs)
        }
    }

//    func handleSceneEvent() {
//        var handler: SceneEventHandler
//        while let event = EventManager.default.sceneEventQueue.dequeue() {
//            switch event.type {
//            }
//            handler.handle()
//        }
//    }

    func updateCharacter(_ timeInterval: TimeInterval) {
        self.applyCharacterVelocity(timeInterval)
        self.updateCharacterVelocity(timeInterval)
        self.resolveCharacterCollision()

        if self.hasMovedToAnotherTile {
            EventManager.default.shouldUpdate.update(with: .interaction)

            if let direction = self.currChunkDirection {
                self.character.moveChunk(direction: direction)
                chunkContainer.update(streetChunkCoord: self.character.streetChunkCoord, direction: direction)
            }
        }

        self.movingLayer.position = -self.character.position
        self.character.lastPosition = self.character.position

        self.saveCharacterPosition()
    }

    private func applyCharacterVelocity(_ timeInterval: TimeInterval) {
        let differenceVector = self.character.velocityVector * timeInterval
        self.character.position += differenceVector
    }

    // TODO: update wrong formula
    private func updateCharacterVelocity(_ timeInterval: TimeInterval) {
        let velocity = self.character.velocityVector.magnitude
        self.character.velocityVector =
            velocity > Constant.velocityDamping
                ? self.character.velocityVector * pow(Constant.velocityFrictionRatioPerSec, timeInterval)
                : CGVector()
    }

    private func resolveCharacterCollision() {
        //        self.character.resolveWorldBorderCollision()
        //        self.character.resolveCollisionOfNonWalkable()
    }

//    private func resolveWorldBorderCollision() {
//        self.character.position.x = self.character.position.x < Constant.moveableArea.minX
//        ? Constant.moveableArea.minX
//        : self.character.position.x
//        self.character.position.x = self.character.position.x > Constant.moveableArea.maxX
//        ? Constant.moveableArea.maxX
//        : self.character.position.x
//        self.character.position.y = self.character.position.y < Constant.moveableArea.minY
//        ? Constant.moveableArea.minY
//        : self.character.position.y
//        self.character.position.y = self.character.position.y > Constant.moveableArea.maxY
//        ? Constant.moveableArea.maxY
//        : self.character.position.y
//    }

    var hasMovedToAnotherTile: Bool {
        let lastTileCoord = TileCoordinate(from: self.character.lastPosition)
        let currTileCoord = TileCoordinate(from: self.character.position)

        return lastTileCoord != currTileCoord
    }

    var currChunkDirection: Direction4? {
        let halfChunkwidth = Constant.chunkWidth / 2.0
        if self.character.position.x > halfChunkwidth {
            return .east
        } else if self.character.position.y < -halfChunkwidth {
            return .south
        } else if self.character.position.x < -halfChunkwidth {
            return .west
        } else if self.character.position.y > halfChunkwidth {
            return .north
        }
        return nil
    }

    func saveCharacterPosition() {
        var streetChunkCoord = self.character.streetChunkCoord
        streetChunkCoord.building = 0

        let buildingCoord = TileCoordinate(from: self.character.position).coord
        let chunkCoord = streetChunkCoord + buildingCoord
        self.character.data.chunkCoord = chunkCoord
    }
}
