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
    init(character: Character) {
        super.init()

        self.isUserInteractionEnabled = true
        self.zPosition = Constant.ZPosition.movingLayer

        // MARK: chunkContainer
        let chunkContainer = ChunkContainer(character: character)
        self.addChild(chunkContainer)
        self.chunkContainer = chunkContainer

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

     // MARK: - touch
    override func touchBegan(_ touch: UITouch) {
        TouchEventHandlerManager.default.cancelAll(of: CharacterMoveTouchEventHandler.self)

        let event = Event(type: .characterTouchBegan,
                          udata: touch,
                          sender: self)
        EventManager.default.enqueue(event)
    }

    override func touchMoved(_ touch: UITouch) {
        guard let handler = TouchEventHandlerManager.default.handler(from: touch) else {
            return
        }

        handler.touchMoved()
    }

    override func touchEnded(_ touch: UITouch) {
        guard let handler = TouchEventHandlerManager.default.handler(from: touch) else {
            return
        }

        handler.touchEnded()
    }

    override func touchCancelled(_ touch: UITouch) {
        guard let handler = TouchEventHandlerManager.default.handler(from: touch) else {
            return
        }

        handler.touchCancelled()
    }

    // MARK: - override
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchBegan(touch) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchMoved(touch) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchEnded(touch) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchCancelled(touch) }
    }

}
