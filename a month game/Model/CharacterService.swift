//
//  CharacterService.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/07.
//

import Foundation
import SpriteKit

class CharacterService {

    let target: Character

    var pChunkCoord: ChunkCoordinate
    var chunkCoord: ChunkCoordinate {
        get { self.target.data.chunkCoord }
        set {
            self.pChunkCoord = self.chunkCoord
            self.target.data.chunkCoord = newValue
        }
    }

    private var _position: CGPoint
    var position: CGPoint {
        get { self._position }
        set {
            self._position.x = self.constrainedNumberToMiddleChunk(newValue.x)
            self._position.y = self.constrainedNumberToMiddleChunk(newValue.y)
            self.nPosition = self.position

            let newTileCoord = CoordinateConverter(newValue).coord
            self.chunkCoord = self.chunkCoord.chunk + newTileCoord

            Services.default.movingLayer.target.position = -self._position
        }
    }
    var nPosition: CGPoint

    private func constrainedNumberToMiddleChunk(_ number: Double) -> Double {
        let chunkWidth = Constant.chunkWidth
        let doubledQ = (number / (chunkWidth / 2.0)).rounded(.towardZero)
        let q = (doubledQ / 2.0).rounded(.toNearestOrAwayFromZero)
        return number - chunkWidth * q
    }

    var velocityVector: CGVector
    var velocityModifier: Double

    var hasMovedToAnotherTile: Bool { self.chunkCoord != self.pChunkCoord }
    var hasMovedToAnotherChunk: Bool { self.chunkCoord.chunk != self.pChunkCoord.chunk }

    var movedChunkDirection: Direction4? {
        self.pChunkCoord.chunkDirection4(to: self.chunkCoord)
    }

    var movedChunkChunkCoord: Coordinate<Int> {
        self.chunkCoord.chunk.coord - self.pChunkCoord.chunk.coord
    }

    // MARK: - init
    init() {
        self.pChunkCoord = ChunkCoordinate()

        self._position = CGPoint()
        self.nPosition = CGPoint()

        self.velocityVector = CGVector()
        self.velocityModifier = 1.0

        self.target = Character()
        // MARK: all stored properties are initilized

        self.pChunkCoord = self.chunkCoord
    }

    func setUp() {
        let tileCoord = self.chunkCoord.address.tile.coord
        self.position = CoordinateConverter(tileCoord).fieldPoint
        self.nPosition = self.position
    }

    func reset() {
        self.chunkCoord = ChunkCoordinate.zero
        self.setUp()
    }

    func addParticle(_ particle: SKShapeNode) {
        self.target.addChild(particle)
    }

    func jumpChunk(direction: Direction4) {
        let offset = direction.coord.cgPoint * Constant.chunkWidth

        self.nPosition += offset
    }

    func update(timeInterval: TimeInterval) {
        self.applyCharacterVelocity(timeInterval)
        self.resolveCharacterCollision()

        self.updateCharacterVelocity(timeInterval)

        self.position = self.nPosition

        if self.hasMovedToAnotherTile {
            FrameCycleUpdateManager.default.update(with: .accessibleGOTracker)
            self.updateSpeedModifier()

            if self.hasMovedToAnotherChunk {
                Services.default.chunkContainer.update()
                Logics.default.invContainer.moveFieldInvToGO()
            }
        }
    }

    func updateSpeedModifier() {
        self.velocityModifier = 1.0

        guard let gos = Services.default.chunkContainer.items(at: self.chunkCoord) else {
            return
        }

        guard !gos.isEmpty else {
            return
        }

        for go in gos {
            let goWalkSpeed = go.type.walkSpeed

            if goWalkSpeed < self.velocityModifier { self.velocityModifier = go.type.walkSpeed
            }
        }
    }

    private func applyCharacterVelocity(_ timeInterval: TimeInterval) {
        let deltaVector = self.velocityVector * timeInterval
        self.nPosition += deltaVector * self.velocityModifier
    }

    // TODO: update wrong formula
    private func updateCharacterVelocity(_ timeInterval: TimeInterval) {
        let velocity = self.velocityVector.magnitude

        if velocity > Constant.velocityDamping {
            let newVelocity = self.velocityVector
                * pow(Constant.velocityFrictionRatioPerSec, timeInterval)
            self.velocityVector = newVelocity
        } else {
            self.velocityVector = CGVector()
        }
    }

    private func resolveCharacterCollision() {
        //        self.resolveWorldBorderCollision()
        self.resolveCollisionOfNonWalkable()
    }

    private func resolveCollisionOfNonWalkable() {
        for go in Logics.default.accessibleGOTracker.gos {
            guard !go.type.isWalkable else { continue }

            let characterRadius = self.target.path!.boundingBox.width / 2.0

            let goFrameInWorld = go.frameInWorld

            let widthRect = CGRect(x: goFrameInWorld.minX - characterRadius,
                                   y: goFrameInWorld.minY,
                                   width: goFrameInWorld.width + characterRadius * 2.0,
                                   height: goFrameInWorld.height)
            let heightRect = CGRect(x: goFrameInWorld.minX,
                                    y: goFrameInWorld.minY - characterRadius,
                                    width: goFrameInWorld.width,
                                    height: goFrameInWorld.height + characterRadius * 2.0)

            if widthRect.contains(self.nPosition)
                || heightRect.contains(self.nPosition) {
                self.resolveTileSideCollision(tileFrame: goFrameInWorld)
            } else {
                self.resolveTilePointCollision(tileFrame: goFrameInWorld)
            }
        }
    }

    //    private func resolveWorldBorderCollision() {
    //        self.nPosition.x = self.nPosition.x < Constant.moveableArea.minX
    //        ? Constant.moveableArea.minX
    //        : self.nPosition.x
    //        self.nPosition.x = self.nPosition.x > Constant.moveableArea.maxX
    //        ? Constant.moveableArea.maxX
    //        : self.nPosition.x
    //        self.nPosition.y = self.nPosition.y < Constant.moveableArea.minY
    //        ? Constant.moveableArea.minY
    //        : self.nPosition.y
    //        self.nPosition.y = self.nPosition.y > Constant.moveableArea.maxY
    //        ? Constant.moveableArea.maxY
    //        : self.nPosition.y
    //    }

//    var currChunkDirection: Direction4? {
//        let halfChunkwidth = Constant.chunkWidth / 2.0
//
//        if self.target.position.x > halfChunkwidth {
//            return .east
//        } else if self.target.position.y < -halfChunkwidth {
//            return .south
//        } else if self.target.position.x < -halfChunkwidth {
//            return .west
//        } else if self.target.position.y > halfChunkwidth {
//            return .north
//        }
//
//        return nil
//    }

    /// - Returns: true if collision resolved else false
    func resolveTileSideCollision(tileFrame: CGRect) {
        let characterRadius = self.target.path!.boundingBox.width / 2.0

        let deltaX = self.nPosition.x - tileFrame.midX
        let deltaY = self.nPosition.y - tileFrame.midY

        let sum = deltaY + deltaX
        let sub = deltaY - deltaX

        if sub < 0 && sum >= 0 {
            self.nPosition.x = tileFrame.maxX + characterRadius
        } else if sub <= 0 && sum < 0 {
            self.nPosition.y = tileFrame.minY - characterRadius
        } else if sub > 0 && sum <= 0 {
            self.nPosition.x = tileFrame.minX - characterRadius
        }else if sub >= 0 && sum > 0 {
            self.nPosition.y = tileFrame.maxY + characterRadius
        }
    }

    // NOTE: optimization possible
    func resolveTilePointCollision(tileFrame: CGRect) {
        let characterRadius = self.target.path!.boundingBox.width / 2.0

        if CGVector(dx: self.nPosition.x - tileFrame.minX, dy: self.nPosition.y - tileFrame.minY).magnitude < characterRadius {
            let deltaX = tileFrame.midX - self.nPosition.x
            let deltaY = tileFrame.midY - self.nPosition.y
            let inclination = deltaY / deltaX
            let yIntercept = (tileFrame.midX * self.nPosition.y - self.nPosition.x * tileFrame.midY) / deltaX
            let temp = yIntercept - tileFrame.minY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - tileFrame.minX
            let c = tileFrame.minX * tileFrame.minX + temp * temp - characterRadius * characterRadius
            self.nPosition.x = (-b - (b * b - a * c).squareRoot()) / a
            self.nPosition.y = inclination * self.nPosition.x + yIntercept
        } else if CGVector(dx: self.nPosition.x - tileFrame.maxX, dy: self.nPosition.y - tileFrame.minY).magnitude < characterRadius {
            let deltaX = tileFrame.midX - self.nPosition.x
            let deltaY = tileFrame.midY - self.nPosition.y
            let inclination = deltaY / deltaX
            let yIntercept = (tileFrame.midX * self.nPosition.y - self.nPosition.x * tileFrame.midY) / deltaX
            let temp = yIntercept - tileFrame.minY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - tileFrame.maxX
            let c = tileFrame.maxX * tileFrame.maxX + temp * temp - characterRadius * characterRadius
            self.nPosition.x = (-b + (b * b - a * c).squareRoot()) / a
            self.nPosition.y = inclination * self.nPosition.x + yIntercept
        } else if CGVector(dx: self.nPosition.x - tileFrame.minX, dy: self.nPosition.y - tileFrame.maxY).magnitude < characterRadius {
            let deltaX = tileFrame.midX - self.nPosition.x
            let deltaY = tileFrame.midY - self.nPosition.y
            let inclination = deltaY / deltaX
            let yIntercept = (tileFrame.midX * self.nPosition.y - self.nPosition.x * tileFrame.midY) / deltaX
            let temp = yIntercept - tileFrame.maxY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - tileFrame.minX
            let c = tileFrame.minX * tileFrame.minX + temp * temp - characterRadius * characterRadius
            self.nPosition.x = (-b - (b * b - a * c).squareRoot()) / a
            self.nPosition.y = inclination * self.nPosition.x + yIntercept
        } else if CGVector(dx: self.nPosition.x - tileFrame.maxX, dy: self.nPosition.y - tileFrame.maxY).magnitude < characterRadius {
            let deltaX = tileFrame.midX - self.nPosition.x
            let deltaY = tileFrame.midY - self.nPosition.y
            let inclination = deltaY / deltaX
            let yIntercept = (tileFrame.midX * self.nPosition.y - self.nPosition.x * tileFrame.midY) / deltaX
            let temp = yIntercept - tileFrame.maxY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - tileFrame.maxX
            let c = tileFrame.maxX * tileFrame.maxX + temp * temp - characterRadius * characterRadius
            self.nPosition.x = (-b + (b * b - a * c).squareRoot()) / a
            self.nPosition.y = inclination * self.nPosition.x + yIntercept
        }
    }

}
