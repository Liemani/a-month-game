//
//  CharacterMoveController.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/17.
//

import Foundation
import SpriteKit

final class CharacterMoveTouchEventHandler {

    private weak var scene: WorldScene!

    private let sender: WorldScene
    let touch: UITouch

    private let character: Character

    private var previousPreviousTimestamp: TimeInterval!
    private var previousTimestamp: TimeInterval!
    private var previousPreviousLocation: CGPoint?

    private var lastCharacterPositionFromMidChunk: CGPoint
    private var characterPositionFromMidChunk: CGPoint

    // MARK: - init
    init(sender: WorldScene, touch: UITouch, worldScene: WorldScene, character: Character) {
        self.sender = sender
        self.touch = touch
        self.scene = worldScene
        self.character = character
        self.lastCharacterPositionFromMidChunk = CGPoint()
        self.characterPositionFromMidChunk = self.character.buildingPosition
        self.lastCharacterPositionFromMidChunk = self.characterPositionFromMidChunk
    }

}

extension CharacterMoveTouchEventHandler: TouchEventHandler {

    func touchBegan() {
        self.previousTimestamp = self.touch.timestamp
        self.character.velocityVector = CGVector()
    }

    func touchMoved() {
        let previousPoint = self.touch.previousLocation(in: self.scene)
        let currentPoint = self.touch.location(in: self.scene)
        let difference = currentPoint - previousPoint

        self.characterPositionFromMidChunk -= difference

        self.previousPreviousTimestamp = self.previousTimestamp
        self.previousTimestamp = self.touch.timestamp
        self.previousPreviousLocation = previousPoint
    }

    func touchEnded() {
        self.setVelocityVector()
    }

    private func setVelocityVector() {
        guard let previousPreviousLocation = self.previousPreviousLocation else {
            return
        }

        let previousLocation = self.touch.previousLocation(in: self.scene)
        let timeInterval = self.previousTimestamp - self.previousPreviousTimestamp

        self.character.velocityVector = -(previousLocation - previousPreviousLocation) / timeInterval
    }

    func touchCancelled() {
    }

}

// MARK: - update
//extension CharacterMoveTouchEventHandler {
//
//    private func tileDidMoved() {
//        let lastTile = TileCoordinate(from: self.lastCharacterPositionFromMidChunk)
//        let currentTile = TileCoordinate(from: self.characterPositionFromMidChunk)
//
//        if currentTile != lastTile {
//            self.interactionZone.reserveUpdate()
//        }
//    }
//
//}
