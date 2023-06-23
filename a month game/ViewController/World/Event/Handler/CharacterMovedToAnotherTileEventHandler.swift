//
//  CharacterMovedToAnotherTileEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation

class CharacterMovedToAnotherTileEventHandler: SceneEventHandler {

    let character: Character

    init(character: Character) {
        self.character = character
    }

    // MARK: - handle
    func handle() {
        self.saveCharacterPosition()
        print("save character location")
        print("update accessable gos")
    }

    func saveCharacterPosition() {
        var streetChunkCoord = self.character.chunkCoord
        streetChunkCoord.building = 0

        let buildingCoord = TileCoordinate(from: self.character.position).coord
        let chunkCoord = streetChunkCoord + buildingCoord
        self.character.data.chunkCoord = chunkCoord
    }

}
