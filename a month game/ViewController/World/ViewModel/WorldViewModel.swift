//
//  WorldViewModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/19.
//

import Foundation
import SpriteKit

class WorldViewModel {

    let movingLayer: MovingLayer

    var chunkContainer: ChunkContainer

    let characterInv: any Inventory

    var fieldInv: (any Inventory)?
    var characterInvInv: (any Inventory)?

    let character: Character

    var accessableGOTracker: AccessableGOTracker

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

        self.accessableGOTracker = AccessableGOTracker()
        WorldUpdateManager.default.update(with: .interaction)
    }

    // MARK: - update
    func update(_ timeInterval: TimeInterval) {
        self.handleWorldEvent()

        self.updateCharacter(timeInterval)
        if WorldUpdateManager.default.contains(.interaction) {
            self.accessableGOTracker.updateWhole(character: self.character,
                                                 gos: self.chunkContainer)
        }
    }

    func handleWorldEvent() {
        while let event = WorldEventManager.default.dequeue() {
            switch event.type {
            case .gameObjectMoveTouchEnded:
                let handler = GameObjectMoveTouchEndedWorldEventHandler(
                    touch: event.udata as! UITouch,
                    go: event.sender as! GameObject,
                    chunkContainer: self.chunkContainer)
                handler.handle()
            case .gameObjectAddToCharacter:
                self.character.addChild(event.sender as! GameObject)
            case .gameObjectAddToChunk:
                self.chunkContainer.add(event.sender as! GameObject)
            case .accessableGOTrackerAdd:
                self.accessableGOTracker.add(event.sender as! GameObject)
            case .accessableGOTrackerRemove:
                self.accessableGOTracker.remove(event.sender as! GameObject)
            }
        }
    }


    func updateCharacter(_ timeInterval: TimeInterval) {
        self.applyCharacterVelocity(timeInterval)
        self.updateCharacterVelocity(timeInterval)
        self.resolveCharacterCollision()

        if self.hasMovedToAnotherTile {
            WorldUpdateManager.default.update(with: .interaction)

            if let direction = self.currChunkDirection {
                self.character.moveChunk(direction: direction)
                chunkContainer.update(direction: direction)
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
        streetChunkCoord.street.building = AddressComponent()

        let buildingCoord = TileCoordinate(from: self.character.position).coord
        let chunkCoord = streetChunkCoord + buildingCoord
        self.character.data.chunkCoord = chunkCoord
    }
}
