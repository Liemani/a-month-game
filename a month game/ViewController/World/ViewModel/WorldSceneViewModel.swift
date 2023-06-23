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

    let characterInv: any Inventory

    var fieldInv: (any Inventory)?
    var characterInvInv: (any Inventory)?

    let movingLayer: MovingLayer
    let character: Character

    var fieldGOs: some Sequence<GameObject> {
        self.chunkContainer.gos
    }

    // MARK: - init
    init(chunkContainer: ChunkContainer,
         characterInv: any Inventory,
         fieldInv: (any Inventory)? = nil,
         characterInvInv: (any Inventory)? = nil,
         movingLayer: MovingLayer,
         character: Character) {
        self.chunkContainer = chunkContainer
        self.characterInv = characterInv
        self.fieldInv = fieldInv
        self.characterInvInv = characterInvInv
        self.movingLayer = movingLayer
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
