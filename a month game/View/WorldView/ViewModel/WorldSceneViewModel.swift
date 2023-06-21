//
//  WorldViewModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/19.
//

import Foundation
import SpriteKit

class WorldSceneViewModel {

    var chunkNodeContainerNode: ChunkNodeContainerNode

//    let characterInv: (any InventoryNode)!
//
//    var fieldInv: (any InventoryNode)?
//    var characterInvInv: (any InventoryNode)?

    let characterNodeMoveManager: CharacterNodeMoveManager

    var fieldGONodes: some Sequence<GameObjectNode> {
        self.chunkNodeContainerNode.goNodes
    }

    // MARK: - init
    init(worldScene: WorldScene) {
        self.chunkNodeContainerNode = worldScene.movingLayer.chunkNodeContainerNode
        self.characterNodeMoveManager = worldScene.characterNodeMoveManager

        let characterPosition = self.characterNodeMoveManager.characterPosition
        self.characterNodeMoveManager.characterPosition = characterPosition
        let characterChunkCoord = self.characterNodeMoveManager.characterChunkCoord
        self.chunkNodeContainerNode.setUp(chunkCoord: characterChunkCoord)
    }

    func updateChunkNode(chunkCoord: ChunkCoordinate, direction: Direction4) {
        print("implement reconsider argument")
    }

    var interactableGONodes: [GameObjectNode] {
        print("rebuild")
        return []
//        var interactableGOs = [GameObjectNode]()
//
//        for goNode in self.chunkNodeContainerNode.goNodes {
//            let characterCoord = self.characterNodeMoveManager.
//            if goNode.intersects(interactionZone) {
//                interactableGOs.append(child)
//            }
//        }
//        return interactableGOs
    }

}
