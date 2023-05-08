//
//  GameScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameController: GameController!

    var tileMapNode: SKTileMapNode!
    var gameObjectLayer: SKNode!
    var uiLayer: SKNode!

    var tileInformationDictionary = Dictionary<String, (SKTileGroup, SKTileDefinition)>()
    let tileIDToKey = [Constant.ResourceName.grassTile, Constant.ResourceName.woodTile]

    // MARK: -
    override func didMove(to view: SKView) {
        self.initLayer()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.gameController.touchDown(touch) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.gameController.touchMoved(touch) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.gameController.touchUp(touch) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.gameController.touchUp(touch) }
    }

    override func update(_ currentTime: TimeInterval) {
        self.gameController.update(currentTime)
    }

    // MARK: -
    func initLayer() {
        initTileDictionary()

        initCamera()
        initTileMapNode()
        initGameObjectLayer()
        initUILayer()
    }

    func initTileDictionary() {
        let grassTileTexture = SKTexture(imageNamed: Constant.ResourceName.grassTile)
        let grassTileDefinition = SKTileDefinition(texture: grassTileTexture)
        let grassTileGroup = SKTileGroup(tileDefinition: grassTileDefinition)
        self.tileInformationDictionary[Constant.ResourceName.grassTile] = (grassTileGroup, grassTileDefinition)

        let woodTileTexture = SKTexture(imageNamed: Constant.ResourceName.woodTile)
        let woodTileDefinition = SKTileDefinition(texture: woodTileTexture)
        let woodTileGroup = SKTileGroup(tileDefinition: woodTileDefinition)
        self.tileInformationDictionary[Constant.ResourceName.woodTile] = (woodTileGroup, woodTileDefinition)
    }

    func initCamera() {
        let camera: SKCameraNode = SKCameraNode()
        self.addChild(camera)
        self.camera = camera
    }

    func initTileMapNode() {
        let tileSet = SKTileSet(tileGroups: [self.tileInformationDictionary[Constant.ResourceName.grassTile]!.0, self.tileInformationDictionary[Constant.ResourceName.woodTile]!.0])

        let tileMapNode = SKTileMapNode(tileSet: tileSet, columns: Constant.gridSize, rows: Constant.gridSize, tileSize: Constant.defaultNodeSize)

        for row in 0..<Constant.gridSize {
            for column in 0..<Constant.gridSize {
                let tileID: Int = self.gameController.gameModel.mapModel.tileMapData[row][column]
                let tileInformation = self.tileInformationDictionary[self.tileIDToKey[tileID]]!
                tileMapNode.setTileGroup(tileInformation.0, andTileDefinition: tileInformation.1, forColumn: column, row: row)
            }
        }

        tileMapNode.position = Constant.screenCenter
        tileMapNode.zPosition = -1

        self.addChild(tileMapNode)
        self.tileMapNode = tileMapNode
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

        let inventoryCellTexture = SKTexture(imageNamed: Constant.ResourceName.inventoryCell)
        for index in 0..<Constant.inventoryCellCount {
            let inventoryCellNode = SKSpriteNode(texture: inventoryCellTexture)
            inventoryCellNode.size = Constant.defaultNodeSize
            inventoryCellNode.position = CGPoint(x: Constant.inventoryCellFirstPosition.x + inventoryCellPositionGap * CGFloat(index), y: Constant.inventoryCellFirstPosition.y)
            uiLayer.addChild(inventoryCellNode)
        }

        self.camera!.addChild(uiLayer)
    }

    func setTile(row: Int, column: Int, tileID: Int) {
        let tileInformation = self.tileInformationDictionary[self.tileIDToKey[tileID]]!
        print("tileID: \(tileID), column: \(column), row: \(row), self.tileIDToKey[tileID]: \(self.tileIDToKey[tileID])")
        self.tileMapNode.setTileGroup(tileInformation.0, andTileDefinition: tileInformation.1, forColumn: column, row: row)
    }
}
