//
//  WorldScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import SpriteKit
import GameplayKit

class WorldScene: SKScene {

    weak var worldSceneController: WorldSceneController!
    var worldSceneTouchController: WorldSceneTouchController!

    var tileMapNode: SKTileMapNode!
    var fieldGameObjectLayer: SKNode!
    var uiLayer: SKNode!
    var menuLayer: SKNode!
    var menuButtonNode: SKNode!
    var exitWorldButtonNode: SKNode!

    // MARK: - set up
    func setUp(worldSceneController: WorldSceneController) {
        self.worldSceneController = worldSceneController

        self.size = Constant.screenSize
        self.scaleMode = .aspectFit

        initTileMapNode()
        initGameObjectLayer()
        initUILayer()
        initMenuLayer()
    }

    func initTileMapNode() {
        let tileGroups = Resource.tileResourceArray.map { $0.tileGroup }
        let tileSet = SKTileSet(tileGroups: tileGroups)

        let tileMapNode = SKTileMapNode(tileSet: tileSet, columns: Constant.gridSize, rows: Constant.gridSize, tileSize: Constant.defaultNodeSize)

        tileMapNode.position = Constant.tileMapNodePosition
        tileMapNode.zPosition = Constant.tileMapNodeZPosition

        self.addChild(tileMapNode)
        self.tileMapNode = tileMapNode
    }

    func initGameObjectLayer() {
        let worldObjectLayer = SKNode()
        worldObjectLayer.zPosition = Constant.worldObjectLayerZPosition

        self.addChild(worldObjectLayer)
        self.fieldGameObjectLayer = worldObjectLayer
    }

    func initUILayer() {
        let uiLayer = SKNode()

        let camera = SKCameraNode()
        camera.position = Constant.tileMapNodePosition
        self.addChild(camera)
        self.camera = camera

        uiLayer.zPosition = Constant.uiLayerZPosition

        let characterNode: SKSpriteNode = SKSpriteNode(imageNamed: Resource.Name.character)
        characterNode.size = Constant.Frame.character.size
        characterNode.position = Constant.Frame.character.origin
        uiLayer.addChild(characterNode)

        let menuButtonNode: SKSpriteNode = SKSpriteNode(imageNamed: Resource.Name.menuButton)
        menuButtonNode.size = Constant.Frame.menuButton.size
        menuButtonNode.position = Constant.Frame.menuButton.origin
        uiLayer.addChild(menuButtonNode)
        self.menuButtonNode = menuButtonNode

        let inventoryCellPositionGap: CGFloat = (Constant.inventoryCellLastPosition.x - Constant.inventoryCellFirstPosition.x) / CGFloat(Constant.inventoryCellCount - 1)

        let inventoryCellTexture = SKTexture(imageNamed: Resource.Name.inventoryCell)
        for index in 0..<Constant.inventoryCellCount {
            let inventoryCellNode = SKSpriteNode(texture: inventoryCellTexture)
            inventoryCellNode.size = Constant.defaultNodeSize
            inventoryCellNode.position = CGPoint(x: Constant.inventoryCellFirstPosition.x + inventoryCellPositionGap * CGFloat(index), y: Constant.inventoryCellFirstPosition.y)
            uiLayer.addChild(inventoryCellNode)
        }

        self.camera!.addChild(uiLayer)
        self.uiLayer = uiLayer
    }

    func initMenuLayer() {
        let menuLayer = SKShapeNode()
        menuLayer.zPosition = Constant.menuLayerZPosition
        menuLayer.isHidden = true

        let menuBackground = SKShapeNode()
        let rect = CGRect(origin: Constant.screenDownLeft, size: Constant.screenSize)
        let path = CGPath(rect: rect, transform: nil)
        menuBackground.path = path
        menuBackground.fillColor = .black
        menuBackground.alpha = 0.5
        menuLayer.addChild(menuBackground)

        let buttonTexture = SKTexture(imageNamed: Resource.Name.button)
        let exitWorldButtonNode = Helper.createLabeledSpriteNode(texture: buttonTexture, in: Constant.Frame.exitWorldButton, labelText: "Exit World", andAddTo: menuLayer)
        exitWorldButtonNode.zPosition = 1.0
        self.exitWorldButtonNode = exitWorldButtonNode

        self.camera!.addChild(menuLayer)
        self.menuLayer = menuLayer
    }

    // MARK: - touoch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.worldSceneController.worldSceneTouchController.touchDown(touch: touch) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.worldSceneController.worldSceneTouchController.touchMoved(touch: touch) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.worldSceneController.worldSceneTouchController.touchUp(touch: touch) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.worldSceneController.worldSceneTouchController.touchUp(touch: touch) }
    }

    override func update(_ currentTime: TimeInterval) {
        self.worldSceneController.update(currentTime: currentTime)
    }

    // MARK: - edit
    func set(row: Int, column: Int, tileTypeID: Int) {
        let resourceIndex = Resource.tileResourceArray.indices.contains(tileTypeID) ? tileTypeID : 0
        let tileInformation = Resource.tileResourceArray[resourceIndex]

        self.tileMapNode.setTileGroup(tileInformation.tileGroup, andTileDefinition: tileInformation.1, forColumn: column, row: row)
    }

    func addSpriteNode(byGameObject gameObject: GameObject) -> SKSpriteNode {
        let textureIndex = Resource.gameObjectTextureArray.indices.contains(gameObject.typeID) ? gameObject.typeID : 0
        let texture = Resource.gameObjectTextureArray[textureIndex]

        let gameObjectSpriteNode = SKSpriteNode(texture: texture)
        let positionX = Constant.defaultSize * (Double(gameObject.coordinate.row) + 0.5)
        let positionY = Constant.defaultSize * (Double(gameObject.coordinate.column) + 0.5)
        gameObjectSpriteNode.position.x = positionX
        gameObjectSpriteNode.position.y = positionY

        self.fieldGameObjectLayer.addChild(gameObjectSpriteNode)

        return gameObjectSpriteNode
    }

    func remove(gameObjectNode: SKNode) {
        gameObjectNode.removeFromParent()
    }

}
