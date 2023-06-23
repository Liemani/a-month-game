//
//  CharacterUpdatePositionEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/23.
//

import Foundation
import SpriteKit

class CharacterUpdatePositionEventHandler: SceneEventHandler {

    let character: Character
    let timeInterval: TimeInterval

    init(character: Character, timeInterval: TimeInterval) {
        self.character = character
        self.timeInterval = timeInterval
    }

    func handle() {
        self.applyVelocity(timeInterval)
        self.updateVelocity(timeInterval)
        self.resolveCollision()

        let event = SceneEvent(type: .characterMoved,
                               udata: nil,
                               sender: self)
        EventManager.default.sceneEventQueue.enqueue(event)
    }

    private func applyVelocity(_ timeInterval: TimeInterval) {
        let differenceVector = self.character.velocityVector * timeInterval
        self.character.position += differenceVector
    }

    private func updateVelocity(_ timeInterval: TimeInterval) {
        let velocity = self.character.velocityVector.magnitude
        self.character.velocityVector =
        velocity <= Constant.velocityDamping
        ? CGVector(dx: 0.0, dy: 0.0)
        // TODO: update wrong formula
        : self.character.velocityVector * pow(Constant.velocityFrictionRatioPerSec, timeInterval)
    }

    private func resolveCollision() {
        //        self.character.resolveWorldBorderCollision()
        //        self.character.resolveCollisionOfNonWalkable()
    }

    private func resolveWorldBorderCollision() {
        self.character.position.x = self.character.position.x < Constant.moveableArea.minX
        ? Constant.moveableArea.minX
        : self.character.position.x
        self.character.position.x = self.character.position.x > Constant.moveableArea.maxX
        ? Constant.moveableArea.maxX
        : self.character.position.x
        self.character.position.y = self.character.position.y < Constant.moveableArea.minY
        ? Constant.moveableArea.minY
        : self.character.position.y
        self.character.position.y = self.character.position.y > Constant.moveableArea.maxY
        ? Constant.moveableArea.maxY
        : self.character.position.y
    }

    //    private func resolveCollisionOfNonWalkable() {
    //        for go in self.character.interactionZone.gos {
    //            guard !go.type.isWalkable else { continue }
    //
    //            if !go.resolveSideCollisionPointWithCircle(ofOrigin: &self.character.position, andRadius: Constant.characterRadius) {
    //                go.resolvePointCollisionPointWithCircle(ofOrigin: &self.character.position, andRadius: Constant.characterRadius)
    //            }
    //        }
    //    }

}
