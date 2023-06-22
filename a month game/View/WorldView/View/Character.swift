//
//  Character.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation
import SpriteKit

class Character: SKShapeNode {

    private let data: CharacterData

    var chunkCoord: ChunkCoordinate { self.data.chunkCoord }
    var buildingPosition: CGPoint { self.data.buildingPosition }

    var velocityVector: CGVector

    let movingLayer: MovingLayer

    var positionFromMidChunk: CGPoint {
        get { -self.movingLayer.position + (Constant.sceneCenter - CGPoint()) }
        set(characterPosition) {
            self.movingLayer.position = -characterPosition + (Constant.sceneCenter - CGPoint())
        }
    }

    // MARK: - init
    init(movingLayer: MovingLayer) {
        self.data = CharacterData()
        self.velocityVector = CGVector()
        self.movingLayer = movingLayer

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

        self.positionFromMidChunk = self.data.buildingPosition
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(_ timeInterval: TimeInterval) {
        self.updatePosition(timeInterval)
        self.updateVelocity(timeInterval)
        self.resolveCollision()
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

//    private func resolveCollisionOfNonWalkable() {
//        for go in self.interactionZone.gos {
//            guard !go.type.isWalkable else { continue }
//
//            if !go.resolveSideCollisionPointWithCircle(ofOrigin: &self.positionFromMidChunk, andRadius: Constant.characterRadius) {
//                go.resolvePointCollisionPointWithCircle(ofOrigin: &self.positionFromMidChunk, andRadius: Constant.characterRadius)
//            }
//        }
//    }

}
