//
//  MovingLayer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/16.
//

import Foundation
import SpriteKit

class MovingLayer: LMINode {

    var chunkContainer: ChunkContainer!

    // MARK: - init
    override init() {
        super.init()

        self.zPosition = Constant.ZPosition.movingLayer

        // MARK: chunkContainer
        let chunkContainer = ChunkContainer()
        self.addChild(chunkContainer)
        self.chunkContainer = chunkContainer

        // MARK: corner
        for direction in DiagonalDirection4.allCases {
            let position = (direction.coord.cgPoint - 0.5) * Constant.chunkWidth
            let corner = SKShapeNode(circleOfRadius: Constant.defaultSize / 4.0)
            corner.fillColor = .white
            corner.position = position
            corner.zPosition = Double.infinity
            self.addChild(corner)
        }

        // MARK: tile
        let resourceName = "tile_default"
        let tileTexture = SKTexture(imageNamed: resourceName)
        let tileDefinition = SKTileDefinition(texture: tileTexture)
        let tileGroup = SKTileGroup(tileDefinition: tileDefinition)
        let tileSet = SKTileSet(tileGroups: [tileGroup])

        let tileMapSide = Constant.tileMapSide
        let tileMap = SKTileMapNode(tileSet: tileSet, columns: tileMapSide, rows: tileMapSide, tileSize: Constant.tileTextureSize)

        tileMap.xScale = Constant.tileScale
        tileMap.yScale = Constant.tileScale
        tileMap.zPosition = Constant.ZPosition.tileMap

        for x in 0..<tileMapSide {
            for y in 0..<tileMapSide {
                tileMap.setTileGroup(tileGroup, andTileDefinition: tileDefinition, forColumn: x, row: y)
            }
        }

        self.addChild(tileMap)
//        tileMap.position = Constant.defaultNodeSize.cgPoint * Double(Constant.tileCountOfChunkSide / 2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
