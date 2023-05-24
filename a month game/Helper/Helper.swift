//
//  Helper.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/11.
//

import UIKit
import SpriteKit

struct Helper {

    @discardableResult
    static func createLabeledSpriteNode(texture: SKTexture, in frame: CGRect, labelText: String, andAddTo parentNode: SKNode) -> SKSpriteNode{
        let spriteNode = SKSpriteNode(texture: texture)
        spriteNode.position = frame.origin
        spriteNode.size = frame.size

        let labelNode = SKLabelNode(text: labelText)
        labelNode.fontSize = Constant.defaultSize / 2
        labelNode.position = CGPoint(x: 0, y: -labelNode.fontSize / 2)
        labelNode.zPosition = 1.0
        spriteNode.addChild(labelNode)

        parentNode.addChild(spriteNode)

        return spriteNode
    }

    // TODO: move to class TileCoordinate: Coordinate<Int>
    static func tileCoordinate(from point: CGPoint) -> Coordinate<Int> {
        let x = Int(point.x) / Int(Constant.tileSide)
        let y = Int(point.y) / Int(Constant.tileSide)
        return Coordinate<Int>(x: x, y: y)
    }

}
