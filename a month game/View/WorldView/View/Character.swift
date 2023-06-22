//
//  Character.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation
import SpriteKit

class Character: SKShapeNode {

    private var data: CharacterData

    var chunkCoord: ChunkCoordinate { self.data.chunkCoord }
    var buildingPosition: CGPoint { self.data.buildingPosition }

    let movingLayer: MovingLayer

    var lastPositionFromMidChunk: CGPoint!
    var positionFromMidChunk: CGPoint {
        get { -self.movingLayer.position + (Constant.sceneCenter - CGPoint()) }
        set(characterPosition) {
            self.movingLayer.position = -characterPosition + (Constant.sceneCenter - CGPoint())
        }
    }

    var velocityVector: CGVector

    // MARK: - init
    init(movingLayer: MovingLayer) {
        self.data = CharacterData()
        self.movingLayer = movingLayer
        self.velocityVector = CGVector()

        super.init()

        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
                    radius: Constant.characterRadius,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        self.path = path
        self.fillColor = .white
        self.strokeColor = .brown
        self.lineWidth = 5.0
        self.position = Constant.sceneCenter
        self.zPosition = Constant.ZPosition.character

        let positionFromMidChunk = self.data.buildingPosition
        self.positionFromMidChunk = positionFromMidChunk
        self.lastPositionFromMidChunk = positionFromMidChunk
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(_ timeInterval: TimeInterval) {
        self.updatePosition(timeInterval)
        self.updateVelocity(timeInterval)
        self.resolveCollision()
        if self.hasMovedToAnotherTile {
            self.savePosition()
            self.lastPositionFromMidChunk = self.positionFromMidChunk
            let event = SceneEvent(type: .characterHasMovedToAnotherTile, udata: nil, sender: self)
            EventManager.default.sceneEventQueue.enqueue(event)
        }
    }

    private func updatePosition(_ timeInterval: TimeInterval) {
        let differenceVector = self.velocityVector * timeInterval
        self.positionFromMidChunk += differenceVector
    }

    private func updateVelocity(_ timeInterval: TimeInterval) {
        let velocity = self.velocityVector.magnitude
        self.velocityVector =
        velocity <= Constant.velocityDamping
        ? CGVector(dx: 0.0, dy: 0.0)
        // TODO: update wrong formula
        : self.velocityVector * pow(Constant.velocityFrictionRatioPerSec, timeInterval)
    }

    private func resolveCollision() {
        //        self.resolveWorldBorderCollision()
//        self.resolveCollisionOfNonWalkable()
    }

    private func resolveWorldBorderCollision() {
        self.positionFromMidChunk.x = self.positionFromMidChunk.x < Constant.moveableArea.minX
            ? Constant.moveableArea.minX
            : self.positionFromMidChunk.x
        self.positionFromMidChunk.x = self.positionFromMidChunk.x > Constant.moveableArea.maxX
            ? Constant.moveableArea.maxX
            : self.positionFromMidChunk.x
        self.positionFromMidChunk.y = self.positionFromMidChunk.y < Constant.moveableArea.minY
            ? Constant.moveableArea.minY
            : self.positionFromMidChunk.y
        self.positionFromMidChunk.y = self.positionFromMidChunk.y > Constant.moveableArea.maxY
            ? Constant.moveableArea.maxY
            : self.positionFromMidChunk.y
    }

    func savePosition() {
        var midChunkCoord = self.chunkCoord
        midChunkCoord.building = 0

        let chunkCoordFromMidChunk = TileCoordinate(from: self.positionFromMidChunk).coord
        let newChunkCoord = midChunkCoord + chunkCoordFromMidChunk
        self.data.chunkCoord = newChunkCoord
    }

//    private func resolveCollisionOfNonWalkable() {
//        for go in self.interactionZone.gos {
//            guard !go.type.isWalkable else { continue }
//
//            if !go.resolveSideCollisionPointWithCircle(ofOrigin: &self.positionFromMidChunk, andRadius: Constant.characterRadius) {
//                go.resolvePointCollisionPointWithCircle(ofOrigin: &self.positionFromMidChunk, andRadius: Constant.characterRadius)
//            }
//        }
//    }

    var hasMovedToAnotherTile: Bool {
        let lastTileCoord = TileCoordinate(from: self.lastPositionFromMidChunk)
        let currTileCoord = TileCoordinate(from: self.positionFromMidChunk)

        return lastTileCoord != currTileCoord
    }

    var currChunkDirection: Direction4? {
        let chunkwidth = Constant.chunkWidth
        if self.positionFromMidChunk.x > chunkwidth {
            return .east
        } else if self.positionFromMidChunk.y < 0.0 {
            return .south
        } else if self.positionFromMidChunk.x < 0.0 {
            return .west
        } else if self.positionFromMidChunk.y > chunkwidth {
            return .north
        }
        return nil
    }

}
