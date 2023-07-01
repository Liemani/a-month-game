//
//  CharacterPositionUpdateHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/27.
//

import Foundation

class CharacterPositionUpdateHandler: EventHandler {

    let character: Character
    let movingLayer: MovingLayer
    let chunkContainer: ChunkContainer
    let accessibleGOTracker: AccessibleGOTracker

    let timeInterval: TimeInterval

    init(character: Character,
         movingLayer: MovingLayer,
         chunkContainer: ChunkContainer,
         accessibleGOTracker: AccessibleGOTracker,
         timeInterval: TimeInterval) {
        self.character = character
        self.movingLayer = movingLayer
        self.chunkContainer = chunkContainer
        self.accessibleGOTracker = accessibleGOTracker
        self.timeInterval = timeInterval
    }

    func handle() {
        self.applyCharacterVelocity(timeInterval)
        self.updateCharacterVelocity(timeInterval)
        self.resolveCharacterCollision()

        if self.hasMovedToAnotherTile {
            FrameCycleUpdateManager.default.update(with: .accessibleGOTracker)

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
        let deltaVector = self.character.velocityVector * timeInterval
        self.character.position += deltaVector
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
        self.resolveCollisionOfNonWalkable()
    }

    private func resolveCollisionOfNonWalkable() {
        for go in self.accessibleGOTracker.gos {
            guard !go.type.isWalkable else { continue }

            let characterRadius = self.character.path!.boundingBox.width / 2.0

            let goFrameOnChunkContainer = go.frame + go.parent!.position

            let widthRect = CGRect(x: goFrameOnChunkContainer.minX - characterRadius,
                                   y: goFrameOnChunkContainer.minY,
                                   width: goFrameOnChunkContainer.width + characterRadius * 2.0,
                                   height: goFrameOnChunkContainer.height)
            let heightRect = CGRect(x: goFrameOnChunkContainer.minX,
                                    y: goFrameOnChunkContainer.minY - characterRadius,
                                    width: goFrameOnChunkContainer.width,
                                    height: goFrameOnChunkContainer.height + characterRadius * 2.0)

            if widthRect.contains(self.character.position)
                || heightRect.contains(self.character.position) {
                self.resolveTileSideCollision(character: self.character,
                                              tileFrame: goFrameOnChunkContainer)
            } else {
                self.resolveTilePointCollision(character: self.character,
                                               tileFrame: goFrameOnChunkContainer)
            }
        }
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
        let lastTileCoord = FieldCoordinate(from: self.character.lastPosition)
        let currTileCoord = FieldCoordinate(from: self.character.position)

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
        var chunkChunkCoord = self.character.chunkChunkCoord
        chunkChunkCoord.address.tile = AddressComponent()

        let tileCoord = FieldCoordinate(from: self.character.position).coord
        let chunkCoord = chunkChunkCoord + tileCoord
        self.character.data.chunkCoord = chunkCoord
    }

    /// - Returns: true if collision resolved else false
    func resolveTileSideCollision(character: Character, tileFrame: CGRect) {
        let characterRadius = character.path!.boundingBox.width / 2.0

        let deltaX = character.position.x - tileFrame.midX
        let deltaY = character.position.y - tileFrame.midY

        let sum = deltaY + deltaX
        let sub = deltaY - deltaX

        if sub < 0 && sum >= 0 {
            character.position.x = tileFrame.maxX + characterRadius
        } else if sub <= 0 && sum < 0 {
            character.position.y = tileFrame.minY - characterRadius
        } else if sub > 0 && sum <= 0 {
            character.position.x = tileFrame.minX - characterRadius
        }else if sub >= 0 && sum > 0 {
            character.position.y = tileFrame.maxY + characterRadius
        }
    }

    // NOTE: optimization possible
    func resolveTilePointCollision(character: Character, tileFrame: CGRect) {
        let characterRadius = character.path!.boundingBox.width / 2.0

        if CGVector(dx: character.position.x - tileFrame.minX, dy: character.position.y - tileFrame.minY).magnitude < characterRadius {
            let deltaX = tileFrame.midX - character.position.x
            let deltaY = tileFrame.midY - character.position.y
            let inclination = deltaY / deltaX
            let yIntercept = (tileFrame.midX * character.position.y - character.position.x * tileFrame.midY) / deltaX
            let temp = yIntercept - tileFrame.minY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - tileFrame.minX
            let c = tileFrame.minX * tileFrame.minX + temp * temp - characterRadius * characterRadius
            character.position.x = (-b - (b * b - a * c).squareRoot()) / a
            character.position.y = inclination * character.position.x + yIntercept
        } else if CGVector(dx: character.position.x - tileFrame.maxX, dy: character.position.y - tileFrame.minY).magnitude < characterRadius {
            let deltaX = tileFrame.midX - character.position.x
            let deltaY = tileFrame.midY - character.position.y
            let inclination = deltaY / deltaX
            let yIntercept = (tileFrame.midX * character.position.y - character.position.x * tileFrame.midY) / deltaX
            let temp = yIntercept - tileFrame.minY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - tileFrame.maxX
            let c = tileFrame.maxX * tileFrame.maxX + temp * temp - characterRadius * characterRadius
            character.position.x = (-b + (b * b - a * c).squareRoot()) / a
            character.position.y = inclination * character.position.x + yIntercept
        } else if CGVector(dx: character.position.x - tileFrame.minX, dy: character.position.y - tileFrame.maxY).magnitude < characterRadius {
            let deltaX = tileFrame.midX - character.position.x
            let deltaY = tileFrame.midY - character.position.y
            let inclination = deltaY / deltaX
            let yIntercept = (tileFrame.midX * character.position.y - character.position.x * tileFrame.midY) / deltaX
            let temp = yIntercept - tileFrame.maxY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - tileFrame.minX
            let c = tileFrame.minX * tileFrame.minX + temp * temp - characterRadius * characterRadius
            character.position.x = (-b - (b * b - a * c).squareRoot()) / a
            character.position.y = inclination * character.position.x + yIntercept
        } else if CGVector(dx: character.position.x - tileFrame.maxX, dy: character.position.y - tileFrame.maxY).magnitude < characterRadius {
            let deltaX = tileFrame.midX - character.position.x
            let deltaY = tileFrame.midY - character.position.y
            let inclination = deltaY / deltaX
            let yIntercept = (tileFrame.midX * character.position.y - character.position.x * tileFrame.midY) / deltaX
            let temp = yIntercept - tileFrame.maxY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - tileFrame.maxX
            let c = tileFrame.maxX * tileFrame.maxX + temp * temp - characterRadius * characterRadius
            character.position.x = (-b + (b * b - a * c).squareRoot()) / a
            character.position.y = inclination * character.position.x + yIntercept
        }
    }

}
