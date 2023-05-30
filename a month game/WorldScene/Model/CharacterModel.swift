//
//  CharacterController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation

class CharacterModel {

    weak var worldScene: WorldScene!

    var position: CGPoint {
        get { -self.worldScene.movingLayer.position }
        set { self.worldScene.movingLayer.position = -newValue }
    }

    private var lastPosition: CGPoint = CGPoint()

    var tileCoord: TileCoordinate { TileCoordinate(from: self.position) }
    var coord: Coordinate<Int> { self.tileCoord.coord }

    var velocityVector: CGVector = CGVector(dx: 0, dy: 0)

    // MARK: init
    init(worldScene: WorldScene) {
        self.worldScene = worldScene
        self.position = TileCoordinate(49, 49).fieldPoint
    }

    // MARK: update
    func update(_ timeInterval: TimeInterval) {
        self.updatePosition(timeInterval)
        self.updateVelocity(timeInterval)
        self.resolveCollision()
        self.didUpdate()
    }
}

// MARK: - private methods
extension CharacterModel {

    private func updatePosition(_ timeInterval: TimeInterval) {
        let differenceVector = self.velocityVector * timeInterval
        self.move(difference: differenceVector)
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
        self.resolveWorldBorderCollision()
        self.resolveCollisionOfNonWalkable()
    }

    private func resolveWorldBorderCollision() {
        self.position.x = self.position.x < Constant.moveableArea.minX
            ? Constant.moveableArea.minX
            : self.position.x
        self.position.x = self.position.x > Constant.moveableArea.maxX
            ? Constant.moveableArea.maxX
            : self.position.x
        self.position.y = self.position.y < Constant.moveableArea.minY
            ? Constant.moveableArea.minY
            : self.position.y
        self.position.y = self.position.y > Constant.moveableArea.maxY
            ? Constant.moveableArea.maxY
            : self.position.y
    }

    private func resolveCollisionOfNonWalkable() {
        for go in self.worldScene.interactionZone.gos {
            guard !go.isWalkable else { continue }

            if !go.resolveSideCollisionPointWithCircle(ofOrigin: &self.position, andRadius: Constant.characterRadius) {
                go.resolvePointCollisionPointWithCircle(ofOrigin: &self.position, andRadius: Constant.characterRadius)
            }
        }
    }

    private func didUpdate() {
        let lastTile = TileCoordinate(from: self.lastPosition)
        let currentTile = TileCoordinate(from: self.position)

        if currentTile != lastTile {
            self.worldScene.interactionZone.reserveUpdate()
        }

        self.lastPosition = self.position
    }

}

// MARK: - concenturate on data edit
extension CharacterModel {

    private func move(difference: CGVector) {
        self.position += difference
    }

}
