//
//  MovingLayer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/16.
//

import Foundation
import SpriteKit

class MovingLayer: LMINode {

    var field: FieldNode!
    var character: SKShapeNode!

    override init() {
        super.init()

        self.zPosition = Constant.ZPosition.movingLayer

        self.addOrigin(to: self)
        self.addField(to: self)
        self.addTileMap(to: self)
    }

    func addOrigin(to parent: SKNode) {
        let origin = SKShapeNode(circleOfRadius: Constant.defaultSize / 2.0)
        origin.zPosition = Double.infinity
        parent.addChild(origin)
    }

    func addField(to parent: SKNode) {
        let field = FieldNode()

        parent.addChild(field)
        self.field = field

        self.addCharacter(to: field)
    }

    func addCharacter(to parent: SKNode) {
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
                    radius: Constant.characterRadius,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        let character = SKShapeNode(path: path)
        character.fillColor = .white
        character.strokeColor = .brown
        character.lineWidth = 5.0
        character.zPosition = 20.0

        parent.addChild(character)

        self.character = character
    }

    func addTileMap(to parent: SKNode) {
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

        parent.addChild(tileMapNode)
        tileMapNode.position = Constant.defaultNodeSize.toCGPoint() * Double(Constant.chunkSide / 2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
