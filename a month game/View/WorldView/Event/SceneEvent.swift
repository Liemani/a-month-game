//
//  LMIEventManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/19.
//

import Foundation

class SceneEvent {

    let sender: Any

    init(sender: Any) {
        self.sender = sender
    }

}

class ChunkMoveSceneEvent: SceneEvent {

    let chunkCoord: ChunkCoordinate
    let direction: Direction4

    init(sender: Any, chunkCoord: ChunkCoordinate, direction: Direction4) {
        self.chunkCoord = chunkCoord
        self.direction = direction

        super.init(sender: sender)
    }

}
