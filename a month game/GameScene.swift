//
//  GameScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var tileLayer: SKNode!
    var gameObjectLayer: SKNode!
    var uiLayer: SKNode!

    override func didMove(to view: SKView) {
        initTileMap()
        initGameObjectLayer()
        initUILayer()
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
    }

    func initTileMap() {
        let grassTile = SKTileDefinition(texture: SKTexture(imageNamed: Constant.ResourceName.tile))
        let tileSet = SKTileSet(tileGroups: [SKTileGroup(tileDefinition: grassTile)])

        let tileMap = SKTileMapNode(tileSet: tileSet, columns: 100, rows: 100, tileSize: Constant.defaultNodeSize)

        tileMap.position = Constant.screenCenter
        tileMap.zPosition = -1

        for row in 0...99 {
            for column in 0...99 {
                tileMap.setTileGroup(SKTileGroup(tileDefinition: grassTile), andTileDefinition: grassTile, forColumn: column, row: row)
            }
        }

        self.addChild(tileMap)
    }

    func initGameObjectLayer() {
        let gameObjectLayer = SKNode()
        self.addChild(gameObjectLayer)
    }

    func initUILayer() {
        let uiLayer = SKNode()

        let characterNode: SKSpriteNode = SKSpriteNode(imageNamed: Constant.ResourceName.character)
        characterNode.size = Constant.Frame.character.size
        characterNode.position = Constant.Frame.character.origin
        uiLayer.addChild(characterNode)

        let menuButtonNode: SKSpriteNode = SKSpriteNode(imageNamed: Constant.ResourceName.menuButton)
        menuButtonNode.size = Constant.Frame.menuButton.size
        menuButtonNode.position = Constant.Frame.menuButton.origin
        uiLayer.addChild(menuButtonNode)

        for index in 0...4 {
            let inventoryCellNode: SKSpriteNode = SKSpriteNode(imageNamed: Constant.ResourceName.inventoryCell)
            inventoryCellNode.size = Constant.Frame.inventoryCell[index].size
            inventoryCellNode.position = Constant.Frame.inventoryCell[index].origin
            uiLayer.addChild(inventoryCellNode)
        }

        self.addChild(uiLayer)
    }

    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
    }

    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }

    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }


    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
