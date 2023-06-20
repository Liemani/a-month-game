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
    var tileMap: SKTileMapNode!
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
        let tileGroups = TileType.tileGroups
        let tileSet = SKTileSet(tileGroups: tileGroups)

        let tileMap = SKTileMapNode(tileSet: tileSet, columns: Constant.gridSize, rows: Constant.gridSize, tileSize: Constant.tileTextureSize)
        tileMap.xScale = Constant.tileScale
        tileMap.yScale = Constant.tileScale

        tileMap.position = Constant.tileMapPosition
        tileMap.zPosition = Constant.ZPosition.tileMap

        parent.addChild(tileMap)
        self.tileMap = tileMap
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
