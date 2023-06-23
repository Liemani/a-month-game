//
//  WorldViewModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/19.
//

import Foundation
import SpriteKit

class WorldSceneViewModel {

    var chunkContainer: ChunkContainer

    let characterInv: any GameObjectContainer

    var fieldInv: (any GameObjectContainer)?
    var characterInvInv: (any GameObjectContainer)?

    let character: Character

    var fieldGOs: some Sequence<GameObject> {
        self.chunkContainer.gos
    }

    // MARK: - init
    init(chunkContainer: ChunkContainer,
         characterInv: any GameObjectContainer,
         fieldInv: (any GameObjectContainer)? = nil,
         characterInvInv: (any GameObjectContainer)? = nil,
         character: Character) {
        self.chunkContainer = chunkContainer
        self.characterInv = characterInv
        self.fieldInv = fieldInv
        self.characterInvInv = characterInvInv
        self.character = character

        chunkContainer.setUp(chunkCoord: character.chunkCoord)
    }

    var interactableGOs: [GameObject] {
        print("rebuild")
        return []
//        var interactableGOs = [GameObjectNode]()
//
//        for go in self.chunkContainer.gos {
//            let characterCoord = self.characterMoveTouchEventHandler.
//            if go.intersects(interactionZone) {
//                interactableGOs.append(child)
//            }
//        }
//        return interactableGOs
    }

}
