//
//  Helper.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/11.
//

import UIKit
import SpriteKit

class Helper {

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

    static func getTypeID(from gameItemType: GameObject.Type) -> Int {
        for (index, information) in Resource.gameItemTypeIDToInformation.enumerated() {
            if gameItemType == information.gameItemType {
                return index
            }
        }
        return 0
    }

}
