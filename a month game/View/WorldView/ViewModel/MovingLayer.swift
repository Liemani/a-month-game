//
//  MovingLayer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/16.
//

import Foundation
import SpriteKit

class MovingLayer: LMINode {

    var chunkNodeContainerNode: ChunkNodeContainerNode!

    // MARK: - init
    override init() {
        super.init()

        self.zPosition = Constant.ZPosition.movingLayer

        // MARK: chunkNodeContainerNode
        let chunkNodeContainerNode = ChunkNodeContainerNode()
        self.addChild(chunkNodeContainerNode)
        self.chunkNodeContainerNode = chunkNodeContainerNode

        // MARK: origin
        let origin = SKShapeNode(circleOfRadius: Constant.defaultSize / 2.0)
        origin.zPosition = Double.infinity
        self.addChild(origin)

        // MARK: tile
        let resourceName = "tile_default"
        let tileTexture = SKTexture(imageNamed: resourceName)
        let tileDefinition = SKTileDefinition(texture: tileTexture)
        let tileGroup = SKTileGroup(tileDefinition: tileDefinition)
        let tileSet = SKTileSet(tileGroups: [tileGroup])

        let tileMapSide = Constant.tileMapSide
        let tileMapNode = SKTileMapNode(tileSet: tileSet, columns: tileMapSide, rows: tileMapSide, tileSize: Constant.tileTextureSize)

        tileMapNode.xScale = Constant.tileScale
        tileMapNode.yScale = Constant.tileScale
        tileMapNode.zPosition = Constant.ZPosition.tileMap

        for x in 0..<tileMapSide {
            for y in 0..<tileMapSide {
                tileMapNode.setTileGroup(tileGroup, andTileDefinition: tileDefinition, forColumn: x, row: y)
            }
        }

        self.addChild(tileMapNode)
        tileMapNode.position = Constant.defaultNodeSize.toCGPoint() * Double(Constant.chunkSide / 2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
