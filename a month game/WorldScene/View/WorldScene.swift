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

    var isMenuOpen: Bool {
        return !menuLayer.isHidden
    }

    // MARK: - touoch
    var touchDownTimestamp: TimeInterval = 0.0
    var touchDownLocation: CGPoint = CGPoint()
    var velocityVector: CGVector = CGVector()

    func touchDown(touch: UITouch) {
        if !self.isMenuOpen {
            let touchLocation = touch.location(in: self.fieldGameObjectLayer)
            if let touchedObjectNode = self.fieldGameObjectLayer.nodes(at: touchLocation).first {
                self.worldSceneController.interactObject(by: touchedObjectNode)
                self.worldSceneController.removeGameObject(by: touchedObjectNode)
            } else {
                self.addGameObjectAtTouchLocation(touch: touch)
            }
            self.startDragging(touch: touch)
        }
    }

    private func addGameObjectAtTouchLocation(touch: UITouch) {
        let scene = self.scene as! WorldScene
        let location = touch.location(in: scene)
        let row = Int(location.x) / Int(Constant.defaultSize)
        let column = Int(location.y) / Int(Constant.defaultSize)

        let coordinate = GameObjectCoordinate(inventoryID: 0, row: row, column: column)
        let typeID = Int(arc4random_uniform(3) + 1)

        let gameObject = GameObject.new(withTypeID: typeID, id: nil, coordinate: coordinate)

        self.worldSceneController.add(gameObject)
    }

    private func startDragging(touch: UITouch) {
        self.touchDownTimestamp = touch.timestamp
        self.touchDownLocation = touch.location(in: self.camera!)
        self.velocityVector = CGVector()
    }

    func touchMoved(touch: UITouch) {
        moveCamera(touch: touch)
    }

    private func moveCamera(touch: UITouch) {
        let currentLocation = touch.location(in: self.camera!)
        let previousLocation = touch.previousLocation(in: self.camera!)

        let dx = currentLocation.x - previousLocation.x
        let dy = currentLocation.y - previousLocation.y

        let oldCameraPosition = self.camera!.position
        let newCameraPosition = CGPoint(x: oldCameraPosition.x - dx, y: oldCameraPosition.y - dy)

        self.camera!.position = newCameraPosition
    }

    func touchUp(touch: UITouch) {
        let scene = self.scene as! WorldScene
        if !self.isMenuOpen {
            let currentLocation = touch.location(in: self.camera!)
            let timeInterval = touch.timestamp - touchDownTimestamp

            let velocityX = -(currentLocation.x - touchDownLocation.x) / timeInterval
            let velocityY = -(currentLocation.y - touchDownLocation.y) / timeInterval
            self.velocityVector = CGVector(dx: velocityX, dy: velocityY)
            if scene.menuButtonNode.contains(currentLocation) {
                scene.menuLayer.isHidden = false
            }
        } else {
            let currentLocation = touch.location(in: self.camera!)
            if scene.exitWorldButtonNode.contains(currentLocation) {
                performSegueToPortalScene()
            } else {
                scene.menuLayer.isHidden = true
            }
        }
    }

    private func performSegueToPortalScene() {
        self.worldSceneController.viewController.setPortalScene()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchDown(touch: touch) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchMoved(touch: touch) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchUp(touch: touch) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchUp(touch: touch) }
    }

    var lastUpdateTime: TimeInterval = 0.0
    override func update(_ currentTime: TimeInterval) {
        let timeInterval: TimeInterval = currentTime - lastUpdateTime

        updateCamera(timeInterval: timeInterval)
        updateVelocity(timeInterval: timeInterval)

        lastUpdateTime = currentTime
    }

    func updateCamera(timeInterval: TimeInterval) {
        let cameraPosition = self.camera!.position
        let newCameraPositionX = cameraPosition.x + self.velocityVector.dx * timeInterval
        let newCameraPositionY = cameraPosition.y + self.velocityVector.dy * timeInterval
        self.camera!.position = CGPoint(x: newCameraPositionX, y: newCameraPositionY)
    }

    func updateVelocity(timeInterval: TimeInterval) {
        let velocity = (self.velocityVector.dx * self.velocityVector.dx + self.velocityVector.dy * self.velocityVector.dy).squareRoot()
        if velocity <= Constant.velocityDamping * timeInterval {
            self.velocityVector = CGVectorMake(0.0, 0.0)
        } else {
            let newVelocityVectorX = self.velocityVector.dx - Constant.velocityDamping / velocity * self.velocityVector.dx * timeInterval
            let newVelocityVectorY = self.velocityVector.dy - Constant.velocityDamping / velocity * self.velocityVector.dy * timeInterval
            self.velocityVector = CGVector(dx: newVelocityVectorX, dy: newVelocityVectorY)
        }
    }

    // MARK: - edit
    func set(row: Int, column: Int, tileTypeID: Int) {
        let resourceIndex = Resource.tileResourceArray.indices.contains(tileTypeID) ? tileTypeID : 0
        let tileInformation = Resource.tileResourceArray[resourceIndex]

        self.tileMapNode.setTileGroup(tileInformation.tileGroup, andTileDefinition: tileInformation.1, forColumn: column, row: row)
    }

    func addSpriteNode(byGameObject gameObject: GameObject) -> SKSpriteNode {
        let texture = Resource.getTexture(of: gameObject)

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
