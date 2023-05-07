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
        initCamera()
        initTileMap()
        initGameObjectLayer()
        initUILayer()
    }

    func initCamera() {
        let camera: SKCameraNode = SKCameraNode()
        self.addChild(camera)
        self.camera = camera
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

        let inventoryCellPositionGap: CGFloat = (Constant.inventoryCellLastPosition.x - Constant.inventoryCellFirstPosition.x) / CGFloat(Constant.inventoryCellCount - 1)

        for index in 0..<Constant.inventoryCellCount {
            let inventoryCellNode: SKSpriteNode = SKSpriteNode(imageNamed: Constant.ResourceName.inventoryCell)
            inventoryCellNode.size = Constant.defaultNodeSize
            inventoryCellNode.position = CGPoint(x: Constant.inventoryCellFirstPosition.x + inventoryCellPositionGap * CGFloat(index), y: Constant.inventoryCellFirstPosition.y)
            uiLayer.addChild(inventoryCellNode)
        }

        self.camera!.addChild(uiLayer)
    }

    // MARK: Touch event
    var touchDownTimestamp: TimeInterval = 0.0
    var touchDownLocation: CGPoint = CGPoint()
    var velocityVector: CGVector = CGVector()

    func touchDown(_ touch: UITouch) {
        self.touchDownTimestamp = touch.timestamp
        self.touchDownLocation = touch.location(in: self.camera!)
        self.velocityVector = CGVector()
    }

    func touchMoved(_ touch: UITouch) {
        let currentLocation = touch.location(in: self.camera!)
        let previousLocation = touch.previousLocation(in: self.camera!)
        let dx = currentLocation.x - previousLocation.x
        let dy = currentLocation.y - previousLocation.y
        let cameraPosition = self.camera!.position
        self.camera!.position = CGPoint(x: cameraPosition.x - dx, y: cameraPosition.y - dy)
    }

    func touchUp(_ touch: UITouch) {
        let currentLocation = touch.location(in: self.camera!)
        let timeInterval = touch.timestamp - touchDownTimestamp

        print("currentLocation: \(currentLocation), touchDownLocation: \(touchDownLocation)")

        let velocityX = -(currentLocation.x - touchDownLocation.x) / timeInterval
        let velocityY = -(currentLocation.y - touchDownLocation.y) / timeInterval
        self.velocityVector = CGVector(dx: velocityX, dy: velocityY)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchDown(touch) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchMoved(touch) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchUp(touch) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchUp(touch) }
    }

    var lastUpdateTime: TimeInterval = 0.0
    override func update(_ currentTime: TimeInterval) {
        let timeInterval: TimeInterval = (currentTime - lastUpdateTime)

        let cameraPosition = self.camera!.position
        let newCameraPositionX = cameraPosition.x + self.velocityVector.dx * timeInterval
        let newCameraPositionY = cameraPosition.y + self.velocityVector.dy * timeInterval
        self.camera!.position = CGPoint(x: newCameraPositionX, y: newCameraPositionY)

        let velocity = (self.velocityVector.dx * self.velocityVector.dx + self.velocityVector.dy * self.velocityVector.dy).squareRoot()
        if velocity != 0.0 {
            print("velocityVector: \(velocityVector), velocity: \(velocity), damping: \(Constant.velocityDamping)")
        }
        if velocity <= Constant.velocityDamping * timeInterval {
            self.velocityVector = CGVector()
        } else {
            let newVelocityVectorX = self.velocityVector.dx - Constant.velocityDamping / velocity * self.velocityVector.dx * timeInterval
            let newVelocityVectorY = self.velocityVector.dy - Constant.velocityDamping / velocity * self.velocityVector.dy * timeInterval
            self.velocityVector = CGVector(dx: newVelocityVectorX, dy: newVelocityVectorY)
        }

        lastUpdateTime = currentTime
    }
}
