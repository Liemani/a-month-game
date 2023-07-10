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

    func addParticle(_ particle: SKShapeNode) {
        self.character.addChild(particle)
    }

}
