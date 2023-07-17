//
//  CharacterLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/07.
//

import Foundation
import SpriteKit

class CharacterLogic {

    private let character: Character

    init(character: Character) {
        self.character = character
    }

    var chunkCoord: ChunkCoordinate { self.character.chunkCoord }
    var chunkChunkCoord: ChunkCoordinate { self.character.chunkChunkCoord }

    func addParticle(_ particle: SKShapeNode) {
        self.character.addChild(particle)
    }

    func resetVelocity() {
        self.character.velocityVector = CGVector()
    }

    func applyPositionDelta(_ delta: CGPoint) {
        self.character.position += delta * self.character.speedModifier
    }

    func setVelocity(_ vector: CGVector) {
        self.character.velocityVector = vector
    }

    func jumpChunk(direction: Direction4) {
        let offset = direction.coord.cgPoint * Constant.chunkWidth

        self.character.position += offset
    }

}
