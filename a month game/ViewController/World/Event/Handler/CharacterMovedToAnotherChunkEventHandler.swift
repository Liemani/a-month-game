//
//  LMIEventManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/19.
//

import Foundation

class CharacterMovedToAnotherChunkEventHandler: SceneEventHandler {

    let chunkContainer: ChunkContainer
    let direction: Direction4

    init(chunkContainer: ChunkContainer,
         direction: Direction4) {
        self.chunkContainer = chunkContainer
        self.direction = direction
    }

    // MARK: - handle
    func handle() {
        chunkContainer.update(direction: self.direction)
    }

}
