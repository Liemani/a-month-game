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

    private var _pChunkCoord: ChunkCoordinate
    private var _chunkCoord: ChunkCoordinate {
        get { self.target.data.chunkCoord }
        set {
            self._pChunkCoord = self._chunkCoord
            self.target.data.chunkCoord = newValue
        }
    }
    var chunkCoord: ChunkCoordinate { self._chunkCoord }

    private var __position: CGPoint
    private var _position: CGPoint {
        get { self.__position }
        set {
            self.__position.x = self.constrainedNumberToMiddleChunk(newValue.x)
            self.__position.y = self.constrainedNumberToMiddleChunk(newValue.y)
            self._nPosition = self._position

            let newTileCoord = CoordinateConverter(newValue).coord
            self._chunkCoord = self._chunkCoord.chunk + newTileCoord

            Services.default.movingLayer.target.position = -self.__position
        }
    }
    private var _nPosition: CGPoint
    func addNPosition(_ delta: CGPoint) {
        _nPosition += delta * self._velocityModifier
    }

    private func constrainedNumberToMiddleChunk(_ number: Double) -> Double {
        let chunkWidth = Constant.chunkWidth
        let doubledQ = (number / (chunkWidth / 2.0)).rounded(.towardZero)
        let q = (doubledQ / 2.0).rounded(.toNearestOrAwayFromZero)
        return number - chunkWidth * q
    }

    var velocityVector: CGVector
    private var _velocityModifier: Double

    var hasMovedToAnotherTile: Bool { self._chunkCoord != self._pChunkCoord }
    var hasMovedToAnotherChunk: Bool { self._chunkCoord.chunk != self._pChunkCoord.chunk }

    var movedChunkDirection: Direction4? {
        self._pChunkCoord.chunkDirection4(to: self._chunkCoord)
    }

    var movedChunkChunkCoord: Coordinate<Int> {
        self._chunkCoord.chunk.coord - self._pChunkCoord.chunk.coord
    }

    // MARK: - init
    init() {
        self._pChunkCoord = ChunkCoordinate()

        self.__position = CGPoint()
        self._nPosition = CGPoint()

        self.velocityVector = CGVector()
        self._velocityModifier = 1.0

        self.target = Character()
        // MARK: all stored properties are initilized

        self._pChunkCoord = self._chunkCoord
    }

    func setUp() {
        let tileCoord = self._chunkCoord.address.tile.coord
        self._position = CoordinateConverter(tileCoord).fieldPoint
        self._nPosition = self._position

        Services.default.chunkContainer.setUp()

        FrameCycleUpdateManager.default.update(with: .accessibleGOTracker)
        self.updateSpeedModifier()
    }

    func reset() {
        self._chunkCoord = ChunkCoordinate.zero
        self.setUp()
    }

    func addParticle(_ particle: SKShapeNode) {
        self.target.addChild(particle)
    }

    func jumpChunk(direction: Direction4) {
        let offset = direction.coord.cgPoint * Constant.chunkWidth

        self._nPosition += offset
    }

    func update(timeInterval: TimeInterval) {
        self.applyCharacterVelocity(timeInterval)
        self.resolveCharacterCollision()

        self.updateCharacterVelocity(timeInterval)

        self._position = self._nPosition

        if self.hasMovedToAnotherTile {
            if self.hasMovedToAnotherChunk {
                Services.default.chunkContainer.update()
                Logics.default.invContainer.moveFieldInvToGO()
            }

            FrameCycleUpdateManager.default.update(with: .accessibleGOTracker)
            self.updateSpeedModifier()
        }
    }

    func updateSpeedModifier() {
        self._velocityModifier = 1.0

        guard let gos = Services.default.chunkContainer.items(at: self._chunkCoord) else {
            return
        }

        guard !gos.isEmpty else {
            return
        }

        for go in gos {
            let goWalkSpeed = go.type.walkSpeed

            if goWalkSpeed < self._velocityModifier {
                self._velocityModifier = go.type.walkSpeed
            }
        }
    }

    private func applyCharacterVelocity(_ timeInterval: TimeInterval) {
        let deltaVector = self.velocityVector * timeInterval
        self._nPosition += deltaVector * self._velocityModifier
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
        for go in Services.default.accessibleGOTracker.tracker.gos {
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

            if widthRect.contains(self._nPosition)
                || heightRect.contains(self._nPosition) {
                self.resolveTileSideCollision(tileFrame: goFrameInWorld)
            } else {
                self.resolveTilePointCollision(tileFrame: goFrameInWorld)
            }
        }
    }

    //    private func resolveWorldBorderCollision() {
    //        self._nPosition.x = self._nPosition.x < Constant.moveableArea.minX
    //        ? Constant.moveableArea.minX
    //        : self._nPosition.x
    //        self._nPosition.x = self._nPosition.x > Constant.moveableArea.maxX
    //        ? Constant.moveableArea.maxX
    //        : self._nPosition.x
    //        self._nPosition.y = self._nPosition.y < Constant.moveableArea.minY
    //        ? Constant.moveableArea.minY
    //        : self._nPosition.y
    //        self._nPosition.y = self._nPosition.y > Constant.moveableArea.maxY
    //        ? Constant.moveableArea.maxY
    //        : self._nPosition.y
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

        let deltaX = self._nPosition.x - tileFrame.midX
        let deltaY = self._nPosition.y - tileFrame.midY

        let sum = deltaY + deltaX
        let sub = deltaY - deltaX

        if sub < 0 && sum >= 0 {
            self._nPosition.x = tileFrame.maxX + characterRadius
        } else if sub <= 0 && sum < 0 {
            self._nPosition.y = tileFrame.minY - characterRadius
        } else if sub > 0 && sum <= 0 {
            self._nPosition.x = tileFrame.minX - characterRadius
        }else if sub >= 0 && sum > 0 {
            self._nPosition.y = tileFrame.maxY + characterRadius
        }
    }

    // NOTE: optimization possible
    func resolveTilePointCollision(tileFrame: CGRect) {
        let characterRadius = self.target.path!.boundingBox.width / 2.0

        if CGVector(dx: self._nPosition.x - tileFrame.minX, dy: self._nPosition.y - tileFrame.minY).magnitude < characterRadius {
            let deltaX = tileFrame.midX - self._nPosition.x
            let deltaY = tileFrame.midY - self._nPosition.y
            let inclination = deltaY / deltaX
            let yIntercept = (tileFrame.midX * self._nPosition.y - self._nPosition.x * tileFrame.midY) / deltaX
            let temp = yIntercept - tileFrame.minY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - tileFrame.minX
            let c = tileFrame.minX * tileFrame.minX + temp * temp - characterRadius * characterRadius
            self._nPosition.x = (-b - (b * b - a * c).squareRoot()) / a
            self._nPosition.y = inclination * self._nPosition.x + yIntercept
        } else if CGVector(dx: self._nPosition.x - tileFrame.maxX, dy: self._nPosition.y - tileFrame.minY).magnitude < characterRadius {
            let deltaX = tileFrame.midX - self._nPosition.x
            let deltaY = tileFrame.midY - self._nPosition.y
            let inclination = deltaY / deltaX
            let yIntercept = (tileFrame.midX * self._nPosition.y - self._nPosition.x * tileFrame.midY) / deltaX
            let temp = yIntercept - tileFrame.minY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - tileFrame.maxX
            let c = tileFrame.maxX * tileFrame.maxX + temp * temp - characterRadius * characterRadius
            self._nPosition.x = (-b + (b * b - a * c).squareRoot()) / a
            self._nPosition.y = inclination * self._nPosition.x + yIntercept
        } else if CGVector(dx: self._nPosition.x - tileFrame.minX, dy: self._nPosition.y - tileFrame.maxY).magnitude < characterRadius {
            let deltaX = tileFrame.midX - self._nPosition.x
            let deltaY = tileFrame.midY - self._nPosition.y
            let inclination = deltaY / deltaX
            let yIntercept = (tileFrame.midX * self._nPosition.y - self._nPosition.x * tileFrame.midY) / deltaX
            let temp = yIntercept - tileFrame.maxY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - tileFrame.minX
            let c = tileFrame.minX * tileFrame.minX + temp * temp - characterRadius * characterRadius
            self._nPosition.x = (-b - (b * b - a * c).squareRoot()) / a
            self._nPosition.y = inclination * self._nPosition.x + yIntercept
        } else if CGVector(dx: self._nPosition.x - tileFrame.maxX, dy: self._nPosition.y - tileFrame.maxY).magnitude < characterRadius {
            let deltaX = tileFrame.midX - self._nPosition.x
            let deltaY = tileFrame.midY - self._nPosition.y
            let inclination = deltaY / deltaX
            let yIntercept = (tileFrame.midX * self._nPosition.y - self._nPosition.x * tileFrame.midY) / deltaX
            let temp = yIntercept - tileFrame.maxY
            let a = inclination * inclination + 1.0
            let b = inclination * temp - tileFrame.maxX
            let c = tileFrame.maxX * tileFrame.maxX + temp * temp - characterRadius * characterRadius
            self._nPosition.x = (-b + (b * b - a * c).squareRoot()) / a
            self._nPosition.y = inclination * self._nPosition.x + yIntercept
        }
    }

}
