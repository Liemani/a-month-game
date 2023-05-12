//
//  WorldScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import SpriteKit
import GameplayKit

class WorldScene: SKScene {

    weak var worldController: WorldSceneController!
    var worldSceneTouchController: WorldSceneTouchController!

    var tileMapNode: SKTileMapNode!
    var worldObjectLayer: SKNode!
    var uiLayer: SKNode!
    var menuLayer: SKNode!
    var menuButtonNode: SKNode!
    var exitWorldButtonNode: SKNode!

    // MARK: - didMove
    override func didMove(to view: SKView) {
        self.initLayer()
    }

    func initLayer() {
        initTileMapNode()
        initGameObjectLayer()
        initUILayer()
        initMenuLayer()
    }

    func initTileMapNode() {
        let tileGroups = Constant.tileTypeInformationArray.map { $0.0 }
        let tileSet = SKTileSet(tileGroups: tileGroups)

        let tileMapNode = SKTileMapNode(tileSet: tileSet, columns: Constant.gridSize, rows: Constant.gridSize, tileSize: Constant.defaultNodeSize)

        for row in 0..<Constant.gridSize {
            for column in 0..<Constant.gridSize {
                let tileID = self.worldController.worldModel.tileMapModel.tileMap[Constant.gridSize * row + column]
                let tileInformation = Constant.tileTypeInformationArray[tileID]
                tileMapNode.setTileGroup(tileInformation.0, andTileDefinition: tileInformation.1, forColumn: column, row: row)
            }
        }

        tileMapNode.position = Constant.tileMapNodePosition
        tileMapNode.zPosition = Constant.tileMapNodeZPosition

        self.addChild(tileMapNode)
        self.tileMapNode = tileMapNode
    }

    func initGameObjectLayer() {
        let worldObjectLayer = SKNode()
        worldObjectLayer.zPosition = Constant.worldObjectLayerZPosition

        for gameItem in self.worldController.worldModel.gameItemModel.gameItemDictionary.values {
            let texture = Constant.gameItemTypeInformationArray[gameItem.typeID]
            let gameItemNode = SKSpriteNode(texture: texture)
            gameItemNode.position.x = Constant.defaultSize * (Double(gameItem.position.row) + 0.5)
            gameItemNode.position.y = Constant.defaultSize * (Double(gameItem.position.column) + 0.5)
            worldObjectLayer.addChild(gameItemNode)
        }

        self.addChild(worldObjectLayer)
        self.worldObjectLayer = worldObjectLayer
    }

    func initUILayer() {
        let uiLayer = SKNode()

        uiLayer.zPosition = Constant.uiLayerZPosition

        let characterNode: SKSpriteNode = SKSpriteNode(imageNamed: Constant.ResourceName.character)
        characterNode.size = Constant.Frame.character.size
        characterNode.position = Constant.Frame.character.origin
        uiLayer.addChild(characterNode)

        let menuButtonNode: SKSpriteNode = SKSpriteNode(imageNamed: Constant.ResourceName.menuButton)
        menuButtonNode.size = Constant.Frame.menuButton.size
        menuButtonNode.position = Constant.Frame.menuButton.origin
        uiLayer.addChild(menuButtonNode)
        self.menuButtonNode = menuButtonNode

        let inventoryCellPositionGap: CGFloat = (Constant.inventoryCellLastPosition.x - Constant.inventoryCellFirstPosition.x) / CGFloat(Constant.inventoryCellCount - 1)

        let inventoryCellTexture = SKTexture(imageNamed: Constant.ResourceName.inventoryCell)
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

        let buttonTexture = SKTexture(imageNamed: Constant.ResourceName.button)
        let exitWorldButtonNode = Helper.createLabeledSpriteNode(texture: buttonTexture, in: Constant.Frame.exitWorldButton, labelText: "Exit World", andAddTo: menuLayer)
        exitWorldButtonNode.zPosition = 1.0
        self.exitWorldButtonNode = exitWorldButtonNode

        self.camera!.addChild(menuLayer)
        self.menuLayer = menuLayer
    }

    // MARK: - touoch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.worldController.worldSceneTouchController.touchDown(touch: touch) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.worldController.worldSceneTouchController.touchMoved(touch: touch) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.worldController.worldSceneTouchController.touchUp(touch: touch) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.worldController.worldSceneTouchController.touchUp(touch: touch) }
    }

    override func update(_ currentTime: TimeInterval) {
        self.worldController.update(currentTime: currentTime)
    }

    // MARK: - set tile
    func setTile(row: Int, column: Int, tileID: Int) {
        let tileInformation = Constant.tileTypeInformationArray[tileID]
        self.tileMapNode.setTileGroup(tileInformation.0, andTileDefinition: tileInformation.1, forColumn: column, row: row)
    }

}
