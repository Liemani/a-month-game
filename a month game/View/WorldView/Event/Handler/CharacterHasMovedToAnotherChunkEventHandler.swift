//
//  LMIEventManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/19.
//

import Foundation

class CharacterHasMovedToAnotherChunkEventHandler {

    init(chunkContainer: ChunkContainer,
         direction: Direction4,
         character: Character) {
        chunkContainer.update(direction: direction)
        character.positionFromMidChunk -= Constant.tileSize.toPoint() * (direction.coord * 16)
        character.lastPositionFromMidChunk = character.positionFromMidChunk
    }

}
