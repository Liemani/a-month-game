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

    let tileMap: SKTileMapNode

    let characterNodeMoveManager: CharacterNodeMoveManager

    init(worldScene: WorldScene) {
        self.fieldNode = worldScene.field
        self.tileMap = worldScene.tileMap
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

    func setUpTileMap(tileMapBufferPointer: UnsafeBufferPointer<Int>) {
        for x in 0..<Constant.gridSize {
            for y in 0..<Constant.gridSize {
                let rawValue = tileMapBufferPointer[x + y * Constant.gridSize]
                let tileType = TileType(rawValue: rawValue) ?? TileType(rawValue: 0)!
                self.set(tileType: tileType, toX: x, y: y)
            }
        }
    }

    func setUpCharacterPosition(characterPosition: CGPoint) {
        self.characterNodeMoveManager.characterPosition = characterPosition
    }

    private func set(tileType: TileType, toX x: Int, y: Int) {
        self.tileMap.setTileGroup(tileType.tileGroup, andTileDefinition: tileType.tileDefinition, forColumn: y, row: x)
    }

}
