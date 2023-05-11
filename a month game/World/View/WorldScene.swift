//
//  WorldScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import SpriteKit
import GameplayKit

class WorldScene: SKScene {

    weak var worldController: WorldController!

    var tileMapNode: SKTileMapNode!
    var worldObjectLayer: SKNode!
    var uiLayer: SKNode!

    let tileIDToKey = [Constant.ResourceName.grassTile, Constant.ResourceName.woodTile, Constant.ResourceName.woodWallTile]
    var tileInformationDictionary = Dictionary<Int, (SKTileGroup, SKTileDefinition)>()

    // MARK: - override
    override func didMove(to view: SKView) {
        initTileDictionary()

        self.initLayer()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.worldController.touchDown(touch) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.worldController.touchMoved(touch) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.worldController.touchUp(touch) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.worldController.touchUp(touch) }
    }

    override func update(_ currentTime: TimeInterval) {
        self.worldController.update(currentTime)
    }

    // MARK: -
    func initLayer() {
        initCamera()
        initTileMapNode()
        initGameObjectLayer()
        initUILayer()
    }

    func initTileDictionary() {
        for tileID in 0..<tileIDToKey.count {
            addTileToDictionary(tileID: tileID)
        }
    }

    func addTileToDictionary(tileID: Int) {
        let tileTexture = SKTexture(imageNamed: tileIDToKey[tileID])
        let tileDefinition = SKTileDefinition(texture: tileTexture)
        let tileGroup = SKTileGroup(tileDefinition: tileDefinition)
        self.tileInformationDictionary[tileID] = (tileGroup, tileDefinition)
    }

    func initCamera() {
        let camera: SKCameraNode = SKCameraNode()
        self.addChild(camera)
        self.camera = camera
    }

    func initTileMapNode() {
        let tileGroups = tileInformationDictionary.values.map { $0.0 }
        let tileSet = SKTileSet(tileGroups: tileGroups)

        let tileMapNode = SKTileMapNode(tileSet: tileSet, columns: Constant.gridSize, rows: Constant.gridSize, tileSize: Constant.defaultNodeSize)

        for row in 0..<Constant.gridSize {
            for column in 0..<Constant.gridSize {
                let tileID = self.worldController.worldModel.tileMapModel.tileMap[Constant.gridSize * row + column]
                let tileInformation = self.tileInformationDictionary[tileID]!
                tileMapNode.setTileGroup(tileInformation.0, andTileDefinition: tileInformation.1, forColumn: column, row: row)
            }
        }

        tileMapNode.position = Constant.screenCenter
        tileMapNode.zPosition = -1.0

        self.addChild(tileMapNode)
        self.tileMapNode = tileMapNode
    }

    func initGameObjectLayer() {
        let worldObjectLayer = SKNode()
        self.addChild(worldObjectLayer)
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
        let tileInformation = self.tileInformationDictionary[tileID]!
        self.tileMapNode.setTileGroup(tileInformation.0, andTileDefinition: tileInformation.1, forColumn: column, row: row)
    }

}
