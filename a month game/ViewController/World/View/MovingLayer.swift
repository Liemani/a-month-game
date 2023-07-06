//
//  MovingLayer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/16.
//

import Foundation
import SpriteKit

class MovingLayer: SKNode {

    var chunkContainer: ChunkContainer!

    // MARK: - init
    init(character: Character) {
        super.init()

        self.zPosition = Constant.ZPosition.movingLayer

        // MARK: chunkContainer
        let chunkContainer = ChunkContainer(character: character)
        self.addChild(chunkContainer)
        self.chunkContainer = chunkContainer

        // MARK: tile
        let tileTexture = SKTexture(imageNamed: Constant.ResourceName.grassTile)
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

// MARK: - touch responder
extension MovingLayer: TouchResponder {

    func touchBegan(_ touch: UITouch) {
            TouchHandlerContainer.default.fieldHandler.began(touch: touch)
    }

    func touchMoved(_ touch: UITouch) {
        let fieldHandler = TouchHandlerContainer.default.fieldHandler

        guard touch == fieldHandler.touch else {
            return
        }

        fieldHandler.moved()
    }

    func touchEnded(_ touch: UITouch) {
        let fieldHandler = TouchHandlerContainer.default.fieldHandler

        guard touch == fieldHandler.touch else {
            return
        }

        fieldHandler.ended()
    }

    func touchCancelled(_ touch: UITouch) {
        let fieldHandler = TouchHandlerContainer.default.fieldHandler

        guard touch == fieldHandler.touch else {
            return
        }

        fieldHandler.cancelled()
    }

}
