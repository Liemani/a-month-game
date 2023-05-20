//
//  WorldScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import SpriteKit
import GameplayKit

class WorldScene: SKScene {

    // TODO: rename to sceneController
    weak var worldSceneController: WorldSceneController!

    // Position of moving layer represents character coordinate
    var movingLayer: SKNode!
    var tileMap: SKTileMapNode!
    var gameObjectField: SKNode!

    var ui: SKNode!
    var menuButton: SKNode!
    var accessBox: SKNode!

    var menuWindow: SKNode!
    var exitWorldButton: SKNode!

    var isMenuOpen: Bool {
        return !menuWindow.isHidden
    }

    var characterPosition: CGPoint {
        get {
            return -self.movingLayer.position
        }
        set {
            self.movingLayer.position = -newValue
        }
    }

    var accessableGameObjects = [SKNode?](repeating: nil, count: 9)

    // MARK: - set up
    func setUp(worldSceneController: WorldSceneController) {
        self.worldSceneController = worldSceneController

        self.size = Constant.sceneSize
        self.scaleMode = .aspectFit

        addMovingLayer(to: self)
        addFixedLayer(to: self)
    }

    // MARK: add moving layer
    func addMovingLayer(to parent: SKNode) {
        let movingLayer = SKNode()

        movingLayer.zPosition = Constant.ZPosition.movingLayer

        parent.addChild(movingLayer)
        self.movingLayer = movingLayer

        addWorldLayer(to: movingLayer)
    }

    func addWorldLayer(to parent: SKNode) {
        let worldLayer = SKNode()

        worldLayer.position = Constant.sceneCenter

        parent.addChild(worldLayer)

        addBackground(to: worldLayer)
        addGameObjectField(to: worldLayer)
    }

    func addBackground(to parent: SKNode) {
        let background = SKNode()

        background.zPosition = Constant.ZPosition.background

        parent.addChild(background)
        addTileMapNode(to: background)
    }

    func addTileMapNode(to parent: SKNode) {
        let tileGroups = Resource.tileTypeToResource.map { $0.tileGroup }
        let tileSet = SKTileSet(tileGroups: tileGroups)

        let tileMap = SKTileMapNode(tileSet: tileSet, columns: Constant.gridSize, rows: Constant.gridSize, tileSize: Constant.defaultNodeSize)

        tileMap.position = Constant.tileMapNodePosition

        parent.addChild(tileMap)
        self.tileMap = tileMap
    }

    func addGameObjectField(to parent: SKNode) {
        let gameObjectField = SKNode()

        gameObjectField.zPosition = Constant.ZPosition.gameObjectField

        parent.addChild(gameObjectField)
        self.gameObjectField = gameObjectField
    }

    // MARK: add fixed layer
    func addFixedLayer(to parent: SKNode) {
        let fixedLayer = SKNode()

        parent.addChild(fixedLayer)

        addAccessBox(to: fixedLayer)
        addUI(to: fixedLayer)
        addMenuWindow(to: fixedLayer)
    }

    func addAccessBox(to parent: SKNode) {
        let accessBox = SKSpriteNode(color: .green, size: Constant.defaultNodeSize * 2.0)

        accessBox.position = Constant.sceneCenter
        accessBox.alpha = 0.1

        parent.addChild(accessBox)
        self.accessBox = accessBox
    }

    func addUI(to parent: SKNode) {
        let ui = SKNode()

        ui.zPosition = Constant.ZPosition.ui

        parent.addChild(ui)
        self.ui = ui

        let character: SKSpriteNode = SKSpriteNode(imageNamed: Resource.Name.character)

        character.position = Constant.Frame.character.origin
        character.size = Constant.Frame.character.size

        ui.addChild(character)

        let menuButton: SKSpriteNode = SKSpriteNode(imageNamed: Resource.Name.menuButton)

        menuButton.position = Constant.Frame.menuButton.origin
        menuButton.size = Constant.Frame.menuButton.size

        ui.addChild(menuButton)
        self.menuButton = menuButton

        let inventoryCellPositionGap: CGFloat = (Constant.inventoryCellLastPosition.x - Constant.inventoryCellFirstPosition.x) / CGFloat(Constant.inventoryCellCount - 1)

        let inventoryCellTexture = SKTexture(imageNamed: Resource.Name.inventoryCell)
        for index in 0..<Constant.inventoryCellCount {
            let inventoryCellNode = SKSpriteNode(texture: inventoryCellTexture)

            inventoryCellNode.position = CGPoint(x: Constant.inventoryCellFirstPosition.x + inventoryCellPositionGap * CGFloat(index), y: Constant.inventoryCellFirstPosition.y)
            inventoryCellNode.size = Constant.defaultNodeSize

            ui.addChild(inventoryCellNode)
        }
    }

    func addMenuWindow(to parent: SKNode) {
        let menuWindow = SKNode()

        menuWindow.zPosition = Constant.ZPosition.menu
        menuWindow.isHidden = true

        parent.addChild(menuWindow)
        self.menuWindow = menuWindow

        let background = SKSpriteNode(color: .black, size: Constant.sceneSize)

        background.position = Constant.sceneCenter
        background.zPosition = -1.0
        background.alpha = 0.5

        menuWindow.addChild(background)

        let buttonTexture = SKTexture(imageNamed: Resource.Name.button)
        let exitWorldButton = Helper.createLabeledSpriteNode(texture: buttonTexture, in: Constant.Frame.exitWorldButton, labelText: "Exit World", andAddTo: menuWindow)
        self.exitWorldButton = exitWorldButton
    }


    // MARK: - touch
    var menuButtonTouch: UITouch? = nil

    var moveTouch: UITouch? = nil
    var previousMoveTouchTimestamp2: TimeInterval!
    var previousMoveTouchTimestamp1: TimeInterval!
    var previousMoveTouchLocation2: CGPoint!
    var velocityVector = CGVector(dx: 0.0, dy: 0.0)

    func touchDown(touch: UITouch) {
        if self.isMenuOpen {
            return
        }

        if touch.is(onThe: self.menuButton) {
            self.menuButton.alpha = 0.5
            menuButtonTouch = touch
        } else if let gameObject = self.gameObjectField.child(at: touch) {
            print("start touch game object node \(gameObject)")
        } else {
            moveTouch = touch
            previousMoveTouchTimestamp1 = touch.timestamp
        }
    }

    private func startDragging(touch: UITouch) {
    }

//    private func addGameObjectAtTouchLocation(touch: UITouch) {
//        let scene = self.scene as! WorldScene
//        let location = touch.location(in: scene)
//        let x = Int(location.x) / Int(Constant.defaultSize)
//        let y = Int(location.y) / Int(Constant.defaultSize)
//
//        let coordinate = GameObjectCoordinate(inventory: 0, x: x, y: y)
//        let typeID = Int(arc4random_uniform(3) + 1)
//
//        let gameObject = GameObject.new(ofTypeID: typeID, id: nil, coordinate: coordinate)
//
//        self.worldSceneController.add(gameObject)
//    }

    func touchMoved(touch: UITouch) {
        if self.isMenuOpen {
            return
        }

        if touch == self.menuButtonTouch {
            self.menuButton.alpha = touch.is(onThe: self.menuButton) ? 0.5 : 1.0
        } else if touch == self.moveTouch {
            self.move(with: touch)
        } else {
            print("no matching touch")
        }
    }

    func move(with touch: UITouch) {
        let previousPoint = touch.previousLocation(in: self)
        let currentPoint = touch.location(in: self)
        let difference = currentPoint - previousPoint

        self.movingLayer.position += difference

        self.previousMoveTouchTimestamp2 = self.previousMoveTouchTimestamp1
        self.previousMoveTouchTimestamp1 = touch.timestamp
        self.previousMoveTouchLocation2 = previousPoint
    }

    private func touchUp(touch: UITouch) {
        if self.isMenuOpen {
            let currentLocation = touch.location(in: self)
            if self.exitWorldButton.contains(currentLocation) {
                performSegueToPortalScene()
            } else {
                self.menuWindow.isHidden = true
            }

            return
        }

        if touch == self.menuButtonTouch {
            if touch.is(onThe: self.menuButton) {
                self.menuWindow.isHidden = false
                self.moveTouch = nil
            }
            self.menuButton.alpha = 1.0
            self.menuButtonTouch = nil
        } else if touch == self.moveTouch {
            setVelocityVector()
        }
    }

    func setVelocityVector() {
        let previousLocation1 = self.moveTouch!.previousLocation(in: self)
        let previousLocation2 = self.previousMoveTouchLocation2!
        let timeInterval = self.previousMoveTouchTimestamp1 - self.previousMoveTouchTimestamp2

        self.velocityVector = -(previousLocation1 - previousLocation2) / timeInterval
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

    // MARK: - update scene
    var lastUpdateTime: TimeInterval = 0.0
    var lastPosition: CGPoint = CGPoint()

    override func update(_ currentTime: TimeInterval) {
        let timeInterval: TimeInterval = currentTime - lastUpdateTime

        self.characterPosition += self.velocityVector * timeInterval

        updateVelocity(timeInterval: timeInterval)

        updateAccessableGameObjects()
        resolveCollision()

        lastUpdateTime = currentTime
        lastPosition = self.characterPosition
    }

    func updateVelocity(timeInterval: TimeInterval) {
        let velocity = self.velocityVector.magnitude
        self.velocityVector =
            velocity <= Constant.velocityDamping
            ? CGVectorMake(0.0, 0.0)
            : self.velocityVector * pow(Constant.velocityFrictionRatioPerSec, timeInterval)
    }

    func updateAccessableGameObjects() {
        guard self.isTileMoved() else { return }

        let accessableNodes = self.gameObjectField.nodes(at: self.accessBox)
        let currentAccessableObjectCount = accessableNodes.count

        guard currentAccessableObjectCount != 0
                || self.accessableGameObjects.first != nil else { return }

        for index in 0..<self.accessableGameObjects.count {
            self.accessableGameObjects[index] = nil
        }

        for (index, accessableNode) in accessableNodes.enumerated() {
            self.accessableGameObjects[index] = accessableNode
        }
    }

    func resolveCollision() {
        let accessableNodes = self.gameObjectField.nodes(at: self.accessBox)
        for accessableNode in accessableNodes {
            let gameObject = self.worldSceneController.gameObjectNodeToModelDictionary[accessableNode]!
            guard !gameObject.isWalkable else { continue }

            if !accessableNode.resolveSideCollisionPointWithCircle(ofOrigin: &self.characterPosition, andRadius: Constant.characterRadius) {
                accessableNode.resolvePointCollisionPointWithCircle(ofOrigin: &self.characterPosition, andRadius: Constant.characterRadius)
            }
        }
    }

    // MARK: - edit
    func set(tileType: Int, toX x: Int, y: Int) {
        let resourceIndex = Resource.tileTypeToResource.indices.contains(tileType) ? tileType : 0
        let tileInformation = Resource.tileTypeToResource[resourceIndex]

        self.tileMap.setTileGroup(tileInformation.tileGroup, andTileDefinition: tileInformation.1, forColumn: y, row: x)
    }

    func add(_ gameObject: GameObject) -> SKSpriteNode {
        let texture = Resource.getTexture(of: gameObject)
        let node = SKSpriteNode(texture: texture)

        node.position = (gameObject.coordinate.toCGPoint() + 0.5) * Constant.defaultSize

        self.gameObjectField.addChild(node)

        return node
    }

    // MARK: - etc
    // TODO: implement
    func isTileMoved() -> Bool {
        let currentPosition = self.characterPosition

        let lastTile = TileCoordinate(self.lastPosition)
        let currentTile = TileCoordinate(currentPosition)

        return currentTile != lastTile
    }

}
