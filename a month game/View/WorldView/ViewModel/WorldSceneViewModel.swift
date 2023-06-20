//
//  WorldViewModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/19.
//

import Foundation
import SpriteKit

class WorldSceneViewModel {

    let fieldNode: FieldNode
//    let characterInv: (any InventoryNode)!
//
//    var fieldInv: (any InventoryNode)?
//    var characterInvInv: (any InventoryNode)?

    let characterNodeMoveManager: CharacterNodeMoveManager

    init(worldScene: WorldScene) {
        self.fieldNode = worldScene.field
        self.characterNodeMoveManager = worldScene.characterNodeMoveManager
    }

    func setUpFieldNode(gos: [GameObject]) {
        for go in gos {
            guard let goCoord = go.coord,
                  self.fieldNode.isValid(goCoord) else {
                continue
            }

            let goNode = GameObjectNode(from: go)
            self.fieldNode.addGO(goNode, to: goCoord)
        }
    }

    func setUpCharacterPosition(characterPosition: CGPoint) {
        self.characterNodeMoveManager.characterPosition = characterPosition
    }

}
