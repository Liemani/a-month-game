//
//  WorldScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import SpriteKit
import GameplayKit

class WorldScene: SKScene {

    weak var sceneController: WorldSceneController!

    var movingLayer: SKNode!
    var worldLayer: SKNode!
    var tileMap: SKTileMapNode!
    var gameObjectLayer: SKNode!

    var ui: SKNode!
    var menuButton: SKNode!
    var accessBox: SKNode!
    var inventory: SKNode!
    var thirdHand: SKNode!

    var leftHandGameObject: SKNode? {
        let firstInventoryCell = self.inventory.children.first
        return firstInventoryCell?.children.first
    }

    var rightHandGameObject: SKNode? {
        let lastInventoryCell = self.inventory.children.last
        return lastInventoryCell?.children.first
    }

    var thirdHandGameObject: SKNode? {
        return self.thirdHand.children.first
    }

    var menuWindow: SKNode!
    var exitWorldButton: SKNode!

    var isMenuOpen: Bool {
        return !menuWindow.isHidden
    }

    var characterPosition: CGPoint {
        get { return -self.movingLayer.position }
        set { self.movingLayer.position = -newValue }
    }

    var accessableGameObjects = [SKNode?](repeating: nil, count: 9)

    // MARK: - set up
    func setUp(worldSceneController: WorldSceneController) {
        self.sceneController = worldSceneController

        self.size = Constant.sceneSize
        self.scaleMode = .aspectFit

        self.addMovingLayer(to: self)
        self.addFixedLayer(to: self)
    }

    // MARK: add moving layer
    func addMovingLayer(to parent: SKNode) {
        let movingLayer = SKNode()

        movingLayer.zPosition = Constant.ZPosition.movingLayer

        parent.addChild(movingLayer)
        self.movingLayer = movingLayer

        self.addWorldLayer(to: movingLayer)
    }

    func addWorldLayer(to parent: SKNode) {
        let worldLayer = SKNode()

        worldLayer.position = Constant.sceneCenter

        parent.addChild(worldLayer)
        self.worldLayer = worldLayer

        self.addTileMap(to: worldLayer)
        self.addGameObjectField(to: worldLayer)
    }

    func addTileMap(to parent: SKNode) {
        let tileGroups = Resource.tileTypeToResource.map { $0.tileGroup }
        let tileSet = SKTileSet(tileGroups: tileGroups)

        let tileMap = SKTileMapNode(tileSet: tileSet, columns: Constant.gridSize, rows: Constant.gridSize, tileSize: Constant.defaultNodeSize)

        tileMap.position = Constant.tileMapNodePosition
        tileMap.zPosition = Constant.ZPosition.tileMap

        parent.addChild(tileMap)
        self.tileMap = tileMap
    }

    func addGameObjectField(to parent: SKNode) {
        let gameObjectField = SKNode()

        gameObjectField.zPosition = Constant.ZPosition.gameObjectLayer

        parent.addChild(gameObjectField)
        self.gameObjectLayer = gameObjectField
    }

    // MARK: add fixed layer
    func addFixedLayer(to parent: SKNode) {
        let fixedLayer = SKNode()

        fixedLayer.zPosition = Constant.ZPosition.fixedLayer

        parent.addChild(fixedLayer)

        self.addUI(to: fixedLayer)
        self.addMenuWindow(to: fixedLayer)
    }

    func addUI(to parent: SKNode) {
        let ui = SKNode()

        ui.zPosition = Constant.ZPosition.ui

        parent.addChild(ui)
        self.ui = ui

        self.addMenuButton(to: ui)
        self.addCharacter(to: ui)
        self.addAccessBox(to: ui)
        self.addInventory(to: ui)
        self.addThirdHand(to: ui)
    }

    func addMenuButton(to parent: SKNode) {
        let menuButton: SKSpriteNode = SKSpriteNode(imageNamed: Resource.Name.menuButton)

        menuButton.position = Constant.Frame.menuButton.origin
        menuButton.size = Constant.Frame.menuButton.size

        parent.addChild(menuButton)
        self.menuButton = menuButton
    }

    func addCharacter(to parent: SKNode) {
        let character: SKSpriteNode = SKSpriteNode(imageNamed: Resource.Name.character)

        character.position = Constant.Frame.character.origin
        character.size = Constant.Frame.character.size

        parent.addChild(character)
    }

    func addAccessBox(to parent: SKNode) {
        let accessBox = SKSpriteNode(color: .green, size: Constant.defaultNodeSize * 2.0)

        accessBox.position = Constant.sceneCenter
        accessBox.alpha = 0.1

        parent.addChild(accessBox)
        self.accessBox = accessBox
    }

    func addInventory(to parent: SKNode) {
        let inventory = SKNode()

        let inventoryCellPositionGap: CGFloat = (Constant.inventoryCellLastPosition.x - Constant.inventoryCellFirstPosition.x) / CGFloat(Constant.inventoryCellCount - 1)
        let inventoryCellTexture = SKTexture(imageNamed: Resource.Name.inventoryCell)
        var inventoryArray = [SKNode](repeating: SKNode(), count: Constant.inventoryCellCount)

        for index in 0..<Constant.inventoryCellCount {
            let inventoryCell = SKSpriteNode(texture: inventoryCellTexture)

            inventoryCell.position = CGPoint(x: Constant.inventoryCellFirstPosition.x + inventoryCellPositionGap * CGFloat(index), y: Constant.inventoryCellFirstPosition.y)
            inventoryCell.size = Constant.defaultNodeSize

            inventory.addChild(inventoryCell)
            inventoryArray[index] = inventoryCell
        }

        parent.addChild(inventory)
        self.inventory = inventory
    }

    func addThirdHand(to parent: SKNode) {
        let thirdHand = SKNode()

        thirdHand.position = Constant.sceneCenter
        thirdHand.alpha = 0.5

        parent.addChild(thirdHand)
        self.thirdHand = thirdHand
    }

    func addMenuWindow(to parent: SKNode) {
        let menuWindow = SKNode()

        menuWindow.zPosition = Constant.ZPosition.menuWindow
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
    // TODO: struct
    var menuButtonTouch: UITouch? = nil

    // TODO: struct
    var moveTouch: UITouch? = nil
    var previousMoveTouchTimestamp2: TimeInterval!
    var previousMoveTouchTimestamp1: TimeInterval!
    var previousMoveTouchLocation2: CGPoint!
    var velocityVector = CGVector(dx: 0.0, dy: 0.0)

    // TODO: struct
    var gameObjectMoveTouch: UITouch? = nil

    // TODO: struct
    var gameObjectTouch: UITouch? = nil
    var touchedGameObject: SKNode? = nil

    // MARK: touch down
    func touchDown(touch: UITouch) {
        if self.isMenuOpen {
            menuWindowTouchDown(touch: touch)
            return
        }

        if touch.is(onThe: self.menuButton) {
            self.menuButton.alpha = 0.5
            menuButtonTouch = touch
            return
        }

        if let thirdHandGameObject = self.thirdHandGameObject,
           touch.is(onThe: thirdHandGameObject) {
            self.gameObjectMoveTouch = touch
            return
        }

        if let gameObject = self.gameObjectLayer.child(at: touch),
           self.accessableGameObjects.contains(gameObject) {
            self.gameObjectTouch = touch
            self.touchedGameObject = gameObject
            return
        }

        if let gameObject = self.inventory.child(at: touch) {
            self.gameObjectTouch = touch
            self.touchedGameObject = gameObject
            return
        }

        moveTouch = touch
        previousMoveTouchTimestamp1 = touch.timestamp
    }

    func menuWindowTouchDown(touch: UITouch) {
        // TODO: implement
    }

    // MARK: touch moved
    func touchMoved(touch: UITouch) {
        if self.isMenuOpen {
            menuWindowTouchMoved(touch: touch)
            return
        }

        if touch == self.menuButtonTouch {
            self.menuButton.alpha = touch.is(onThe: self.menuButton) ? 0.5 : 1.0
            return
        }

        if touch == self.gameObjectMoveTouch {
            self.thirdHand.position = touch.location(in: self.ui)
            return
        }

        if touch == self.gameObjectTouch {
            if !touch.is(onThe: self.touchedGameObject!) {
                if self.thirdHandGameObject == nil {
                    self.gameObjectMoveTouch = touch
                    self.thirdHand.position = touch.location(in: self.ui)
                    self.touchedGameObject!.move(toParent: self.thirdHand)
                    self.touchedGameObject!.position = CGPoint()
                    self.sceneController.move(self.touchedGameObject!, to: GameObjectCoordinate(inventory: .thirdHand, x: 0, y: 0))
                }

                self.gameObjectTouch = nil
                self.touchedGameObject = nil
            }
            return
        }

        if touch == self.moveTouch {
            self.move(with: touch)
            return
        }
    }

    func menuWindowTouchMoved(touch: UITouch) {
        // TODO: implement
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

    // MARK: touch up
    private func touchUp(touch: UITouch) {
        if self.isMenuOpen {
            menuWindowTouchUp(touch: touch)
            return
        }

        if touch == self.menuButtonTouch {
            if touch.is(onThe: self.menuButton) {
                self.menuWindow.isHidden = false
                self.moveTouch = nil
            }
            self.menuButton.alpha = 1.0
            self.menuButtonTouch = nil
            return
        }

        if touch == self.gameObjectTouch {
            self.sceneController.interact(with: self.touchedGameObject!, leftHand: self.leftHandGameObject, righthand: self.rightHandGameObject)
            self.gameObjectTouch = nil
            self.touchedGameObject = nil
        }

        if touch == self.gameObjectMoveTouch {
            if let cell = self.inventory.child(at: touch) {
                let movingGameObject = self.thirdHandGameObject!
                movingGameObject.move(toParent: cell)
                movingGameObject.position = CGPoint()
                let coordinate = GameObjectCoordinate(inventory: .inventory, tileCoordinate: TileCoordinate(x: cell.firstIndexFromParent!, y: 0))
                self.sceneController.move(movingGameObject, to: coordinate)

                self.gameObjectMoveTouch = nil
                return
            }

            let characterTileCoordinate = TileCoordinate(self.characterPosition)
            let touchTileCoordinate = TileCoordinate(touch.location(in: worldLayer))
            if touchTileCoordinate.isAdjacent(coordinate: characterTileCoordinate) {
                let movingGameObject = self.thirdHandGameObject!
                movingGameObject.move(toParent: gameObjectLayer)
                // TODO: make function for calculate tile coordinate
                movingGameObject.position = (touchTileCoordinate.toCGPoint() + 0.5) * Constant.tileSide
                let coordinate = GameObjectCoordinate(inventory: .field, tileCoordinate: touchTileCoordinate)
                self.sceneController.move(movingGameObject, to: coordinate)

                self.gameObjectMoveTouch = nil
                return
            }
        }

        if touch == self.moveTouch {
            setVelocityVector()
            return
        }
    }

    func menuWindowTouchUp(touch: UITouch) {
        let currentLocation = touch.location(in: self)
        if self.exitWorldButton.contains(currentLocation) {
            performSegueToPortalScene()
        } else {
            self.menuWindow.isHidden = true
        }
    }

    func performSegueToPortalScene() {
        self.sceneController.viewController.setPortalScene()
    }

    func setVelocityVector() {
        guard let previousLocation2 = self.previousMoveTouchLocation2 else { return }
        let previousLocation1 = self.moveTouch!.previousLocation(in: self)
        let timeInterval = self.previousMoveTouchTimestamp1 - self.previousMoveTouchTimestamp2

        self.velocityVector = -(previousLocation1 - previousLocation2) / timeInterval
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
        guard self.isMovedTile() else { return }

        let accessableNodes = self.gameObjectLayer.nodes(at: self.accessBox)
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
        let accessableNodes = self.gameObjectLayer.nodes(at: self.accessBox)
        for accessableNode in accessableNodes {
            let gameObject = self.sceneController.nodeToGameObject[accessableNode]!
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

        node.zPosition = 1.0

        switch gameObject.coordinate.inventory {
        case .field:
            node.position = (gameObject.coordinate.toCGPoint() + 0.5) * Constant.defaultSize

            self.gameObjectLayer.addChild(node)
        case .inventory:
            let inventoryIndex = gameObject.coordinate.x
            let inventoryCell = self.inventory.children.safeSubscrirpt(inventoryIndex)
            inventoryCell.addChild(node)
        case .thirdHand:
            self.thirdHand.addChild(node)
        }

        return node
    }

    // MARK: - etc
    func isMovedTile() -> Bool {
        let currentPosition = self.characterPosition

        let lastTile = TileCoordinate(self.lastPosition)
        let currentTile = TileCoordinate(currentPosition)

        return currentTile != lastTile
    }

}
