//
//  CharacterMoveController.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/17.
//

import Foundation
import SpriteKit

class CharacterNodeMoveManager {

    weak var scene: WorldScene!
    private var touchContextManager: WorldSceneTouchContextManager { self.scene.touchContextManager }
    #warning("remove the concep of interaction zone")
    private var interactionZone: InteractionZone { self.scene.interactionZone }

    private let movingLayer: MovingLayer
    private let character: Character

    var characterChunkCoord: ChunkCoordinate {
        self.character.chunkCoord
    }

    var characterBuildingPosition: CGPoint {
        self.character.buildingPosition
    }

    private var velocityVector: CGVector

    private var lastCharacterPositionFromMidChunkNode: CGPoint
    var characterPositionFromMidChunkNode: CGPoint {
        get { -self.movingLayer.position + (Constant.sceneCenter - CGPoint()) }
        set(characterPosition) {
            self.lastCharacterPositionFromMidChunkNode = self.characterPositionFromMidChunkNode
            self.movingLayer.position = -characterPosition + (Constant.sceneCenter - CGPoint())
        }
    }

    // MARK: - init
    init(worldScene: WorldScene) {
        self.scene = worldScene
        self.movingLayer = worldScene.movingLayer

        self.velocityVector = CGVector()
        self.lastCharacterPositionFromMidChunkNode = CGPoint()
        self.character = Character()
        self.characterPositionFromMidChunkNode = self.character.buildingPosition
        self.lastCharacterPositionFromMidChunkNode = self.characterPositionFromMidChunkNode
    }

}

// MARK: - touch responder
class CharacterMoveTouch: TouchContext {

    var previousPreviousTimestamp: TimeInterval!
    var previousTimestamp: TimeInterval!
    var previousPreviousLocation: CGPoint!

}

extension CharacterNodeMoveManager: LMITouchResponder {

    func touchBegan(_ touch: UITouch) {
        guard self.touchContextManager.first(of: CharacterMoveTouch.self) == nil else {
            return
        }

        let movingLayerTouch = CharacterMoveTouch(touch: touch, sender: self)
        movingLayerTouch.previousTimestamp = touch.timestamp
        self.touchContextManager.add(movingLayerTouch)
    }

    func touchMoved(_ touch: UITouch) {
        guard let movingLayerTouch = self.touchContextManager.first(from: touch) as! CharacterMoveTouch? else {
            return
        }

        let previousPoint = touch.previousLocation(in: self.scene)
        let currentPoint = touch.location(in: self.scene)
        let difference = currentPoint - previousPoint

        self.characterPositionFromMidChunkNode -= difference

        movingLayerTouch.previousPreviousTimestamp = movingLayerTouch.previousTimestamp
        movingLayerTouch.previousTimestamp = touch.timestamp
        movingLayerTouch.previousPreviousLocation = previousPoint
    }

    func touchEnded(_ touch: UITouch) {
        guard self.touchContextManager.first(from: touch) != nil else {
            return
        }

        self.setVelocityVector()
        self.resetTouch(touch)
    }

    private func setVelocityVector() {
        let movingLayerTouch = self.touchContextManager.first(of: CharacterMoveTouch.self) as! CharacterMoveTouch

        guard let previousPreviousLocation = movingLayerTouch.previousPreviousLocation else {
            return
        }

        let previousLocation = movingLayerTouch.uiTouch.previousLocation(in: self.scene)
        let timeInterval = movingLayerTouch.previousTimestamp - movingLayerTouch.previousPreviousTimestamp

        self.velocityVector = -(previousLocation - previousPreviousLocation) / timeInterval
    }

    func touchCancelled(_ touch: UITouch) {
        guard self.touchContextManager.first(from: touch) != nil else { return }
        self.resetTouch(touch)
    }

    func resetTouch(_ touch: UITouch) {
        self.touchContextManager.removeFirst(from: touch)
    }

}

// MARK: - update
extension CharacterNodeMoveManager {

    // MARK: update
    func update(_ timeInterval: TimeInterval) {
        self.updatePosition(timeInterval)
        self.updateVelocity(timeInterval)
        self.resolveCollision()
        self.tileDidMoved()
    }

    private func updatePosition(_ timeInterval: TimeInterval) {
        let differenceVector = self.velocityVector * timeInterval
        self.characterPositionFromMidChunkNode += differenceVector
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
        self.resolveCollisionOfNonWalkable()
    }

    private func resolveWorldBorderCollision() {
        self.characterPositionFromMidChunkNode.x = self.characterPositionFromMidChunkNode.x < Constant.moveableArea.minX
        ? Constant.moveableArea.minX
        : self.characterPositionFromMidChunkNode.x
        self.characterPositionFromMidChunkNode.x = self.characterPositionFromMidChunkNode.x > Constant.moveableArea.maxX
        ? Constant.moveableArea.maxX
        : self.characterPositionFromMidChunkNode.x
        self.characterPositionFromMidChunkNode.y = self.characterPositionFromMidChunkNode.y < Constant.moveableArea.minY
        ? Constant.moveableArea.minY
        : self.characterPositionFromMidChunkNode.y
        self.characterPositionFromMidChunkNode.y = self.characterPositionFromMidChunkNode.y > Constant.moveableArea.maxY
        ? Constant.moveableArea.maxY
        : self.characterPositionFromMidChunkNode.y
    }

    private func resolveCollisionOfNonWalkable() {
        for go in self.interactionZone.gos {
            guard !go.type.isWalkable else { continue }

            if !go.resolveSideCollisionPointWithCircle(ofOrigin: &self.characterPositionFromMidChunkNode, andRadius: Constant.characterRadius) {
                go.resolvePointCollisionPointWithCircle(ofOrigin: &self.characterPositionFromMidChunkNode, andRadius: Constant.characterRadius)
            }
        }
    }

    private func tileDidMoved() {
        let lastTile = TileCoordinate(from: self.lastCharacterPositionFromMidChunkNode)
        let currentTile = TileCoordinate(from: self.characterPositionFromMidChunkNode)

        if currentTile != lastTile {
            self.interactionZone.reserveUpdate()
        }
    }

}
