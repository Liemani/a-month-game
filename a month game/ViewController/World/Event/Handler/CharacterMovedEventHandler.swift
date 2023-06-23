//
//  CharacterMovedEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/23.
//

import Foundation

class CharacterMovedEventHandler: SceneEventHandler {

    let character: Character
    let movingLayer: MovingLayer

    init(character: Character, movingLayer: MovingLayer) {
        self.character = character
        self.movingLayer = movingLayer
    }

    // MARK: - handle
    func handle() {
        if self.hasMovedToAnotherTile {
            let event = SceneEvent(type: .characterMovedToAnotherTile,
                                   udata: nil,
                                   sender: self)
            EventManager.default.sceneEventQueue.enqueue(event)
        }

        if let direction = self.currChunkDirection {
            let event = SceneEvent(type: .characterMovedToAnotherChunk,
                                   udata: direction,
                                   sender: self)
            EventManager.default.sceneEventQueue.enqueue(event)

            self.character.position -= (direction.coord * 16).cgPoint * Constant.tileWidth
        }

        self.movingLayer.position = -self.character.position
        self.character.lastPosition = self.character.position
    }

    var hasMovedToAnotherTile: Bool {
        let lastTileCoord = TileCoordinate(from: self.character.lastPosition)
        let currTileCoord = TileCoordinate(from: self.character.position)

        return lastTileCoord != currTileCoord
    }

    var currChunkDirection: Direction4? {
        let halfChunkwidth = Constant.chunkWidth / 2.0
        if self.character.position.x > halfChunkwidth {
            return .east
        } else if self.character.position.y < -halfChunkwidth {
            return .south
        } else if self.character.position.x < -halfChunkwidth {
            return .west
        } else if self.character.position.y > halfChunkwidth {
            return .north
        }
        return nil
    }

}
