//
//  CharacterMovedToAnotherTileEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation

class CharacterHasMovedToAnotherTileEventHandler {

    init(character: Character) {
        print("update accessable gos")

        guard let currChunkDirection = character.currChunkDirection else {
            return
        }

        let event = SceneEvent(type: .characterHasMovedToAnotherChunk, udata: currChunkDirection, sender: self)
        EventManager.default.sceneEventQueue.enqueue(event)
    }

}
