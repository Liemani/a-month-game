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
    var inventory: InventoryNode!
    var thirdHand: SKNode!

    var leftHandGameObject: SKNode? {
        let firstInventoryCell = self.inventory.children.first
        return firstInventoryCell?.children.first
    }

    var rightHandGameObject: SKNode? {
        let lastInventoryCell = self.inventory.children.last
        return lastInventoryCell?.children.first
    }

    var carryingGameObject: GameObject? {
        return self.thirdHand.children.first as! GameObject?
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

    var accessableGameObjects = [GameObject?](repeating: nil, count: 9)

    // MARK: - initialize
    func initialize(worldSceneController: WorldSceneController) {
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
        let tileGroups = TileType.tileGroups
        let tileSet = SKTileSet(tileGroups: tileGroups)

        let tileMap = SKTileMapNode(tileSet: tileSet, columns: Constant.gridSize, rows: Constant.gridSize, tileSize: Constant.defaultNodeSize)

        tileMap.position = Constant.tileMapPosition
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
        let inventory = InventoryNode()
        inventory.initialize()

        parent.addChild(inventory)
        self.inventory = inventory
    }

    func addThirdHand(to parent: SKNode) {
        let thirdHand = SKNode()

        thirdHand.position = Constant.sceneCenter

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
    func touchBegan(_ touch: UITouch) {
        if self.isMenuOpen {
            self.menuWindowTouchBegan(touch)
            return
        }

        if self.isMenuButtonTouched(touch) {
            self.menuButtonTouchBegan(touch)
            return
        }

        if self.isThirdHandObjectTouch(touch) {
            self.carryTouchBegan(touch)
            return
        }

        if self.isFieldGameObjectTouched(touch) {
            self.gameObjectTouchBegan(touch)
            return
        }

        if self.isInventoryGameObjectTouched(touch) {
            self.gameObjectTouchBegan(touch)
            return
        }

        if moveTouch == nil {
            moveTouchBegan(touch)
            return
        }
    }

    func touchMoved(_ touch: UITouch) {
        if self.isMenuOpen {
            self.menuWindowTouchMoved(touch)
            return
        }

        switch touch {
        case self.menuButtonTouch:
            self.menuButtonTouchMoved(touch)
        case self.gameObjectTouch:
            self.gameObjectTouchMoved(touch)
        case self.carryTouch:
            carryTouchMoved(touch)
        case self.moveTouch:
            self.moveTouchMoved(touch)
        default: break
        }
    }

    private func touchEnded(_ touch: UITouch) {
        if self.isMenuOpen {
            self.menuWindowTouchEnded(touch)
            return
        }

        switch touch {
        case self.menuButtonTouch:
            self.menuButtonTouchEnded(touch)
        case self.gameObjectTouch:
            self.gameObjectTouchEnded(touch)
        case self.carryTouch:
            carryTouchEnded(touch)
        case self.moveTouch:
            self.moveTouchEnded(touch)
        default: break
        }
    }

    func touchCancelled(_ touch: UITouch) {
        if self.isMenuOpen {
            self.menuWindowTouchCancelled(touch)
            return
        }

        switch touch {
        case self.menuButtonTouch:
            self.menuButtonTouchCancelled(touch)
        case self.gameObjectTouch:
            self.gameObjectTouchCancelled(touch)
        case self.carryTouch:
            carryTouchCancelled(touch)
        case self.moveTouch:
            self.moveTouchCancelled(touch)
        default: break
        }
    }

    // MARK: - touch structure
    // MARK: - button touch
    var menuButtonTouch: UITouch? = nil

    func isMenuButtonTouched(_ touch: UITouch) -> Bool {
        return touch.is(onThe: self.menuButton)
    }

    func menuButtonTouchBegan(_ touch: UITouch) {
        self.menuButton.alpha = 0.5
        self.menuButtonTouch = touch
    }

    func menuButtonTouchMoved(_ touch: UITouch) {
        self.menuButton.alpha = touch.is(onThe: self.menuButton) ? 0.5 : 1.0
    }

    func menuButtonTouchEnded(_ touch: UITouch) {
        if touch.is(onThe: self.menuButton) {
            self.menuWindow.isHidden = false
            self.moveTouchCancelled(touch)
            self.gameObjectTouchCancelled(touch)
            self.carryTouchCancelled(touch)
        }
        self.menuButtonTouchReset(touch)
    }

    func menuButtonTouchCancelled(_ touch: UITouch) {
        self.menuButtonTouchReset(touch)
    }

    func menuButtonTouchReset(_ touch: UITouch) {
        self.menuButton.alpha = 1.0
        self.menuButtonTouch = nil
    }

    // MARK: - move touch
    var moveTouch: UITouch? = nil
    var previousMoveTouchTimestamp2: TimeInterval!
    var previousMoveTouchTimestamp1: TimeInterval!
    var previousMoveTouchLocation2: CGPoint!

    func moveTouchBegan(_ touch: UITouch) {
        self.moveTouch = touch
        self.previousMoveTouchTimestamp1 = touch.timestamp
    }

    func moveTouchMoved(_ touch: UITouch) {
        let previousPoint = touch.previousLocation(in: self)
        let currentPoint = touch.location(in: self)
        let difference = currentPoint - previousPoint

        self.movingLayer.position += difference

        self.previousMoveTouchTimestamp2 = self.previousMoveTouchTimestamp1
        self.previousMoveTouchTimestamp1 = touch.timestamp
        self.previousMoveTouchLocation2 = previousPoint
    }

    func moveTouchEnded(_ touch: UITouch) {
        setVelocityVector()

        self.moveTouchReset(touch)
    }

    func moveTouchCancelled(_ touch: UITouch) {
        self.moveTouchReset(touch)
    }

    func moveTouchReset(_ touch: UITouch) {
        self.moveTouch = nil
    }

    func setVelocityVector() {
        guard let previousLocation2 = self.previousMoveTouchLocation2 else { return }
        let previousLocation1 = self.moveTouch!.previousLocation(in: self)
        let timeInterval = self.previousMoveTouchTimestamp1 - self.previousMoveTouchTimestamp2

        self.velocityVector = -(previousLocation1 - previousLocation2) / timeInterval
    }

    // MARK: - game object touch
    var gameObjectTouch: UITouch? = nil
    var touchedGameObject: GameObject? = nil

    func isFieldGameObjectTouched(_ touch: UITouch) -> Bool {
        if let gameObject = self.gameObjectLayer.directChild(at: touch) as! GameObject?,
           self.accessableGameObjects.contains(gameObject) {
            self.touchedGameObject = gameObject
            return true
        }

        return false
    }

    func isInventoryGameObjectTouched(_ touch: UITouch) -> Bool {
        if let gameObject = self.inventory.gameObject(at: touch) {
            self.touchedGameObject = gameObject
            return true
        }

        return false
    }

    func gameObjectTouchBegan(_ touch: UITouch) {
        self.gameObjectTouch = touch
        self.touchedGameObject!.alpha = 0.5
    }

    func gameObjectTouchMoved(_ touch: UITouch) {
        if !touch.is(onThe: self.touchedGameObject!) {
            if self.carryingGameObject == nil && self.touchedGameObject!.isPickable {
                self.thirdHand.position = touch.location(in: self.ui)
                self.touchedGameObject!.move(toParent: self.thirdHand)
                self.touchedGameObject!.position = CGPoint()
                let coordinate = GameObjectCoordinate(containerType: .thirdHand, x: 0, y: 0)
                self.sceneController.move(self.touchedGameObject!, to: coordinate)

                self.gameObjectTouchReset(touch)
                self.carryTouchBegan(touch)
            } else {
                self.gameObjectTouchCancelled(touch)
            }
        }
    }

    func gameObjectTouchEnded(_ touch: UITouch) {
        self.sceneController.interact(with: self.touchedGameObject!, leftHand: self.leftHandGameObject, righthand: self.rightHandGameObject)
        self.touchedGameObject!.alpha = 1.0

        self.gameObjectTouchReset(touch)
    }

    func gameObjectTouchCancelled(_ touch: UITouch) {
        self.touchedGameObject?.alpha = 1.0

        self.gameObjectTouchReset(touch)
    }

    func gameObjectTouchReset(_ touch: UITouch) {
        self.gameObjectTouch = nil
        self.touchedGameObject = nil
    }

    // MARK: - carry touch
    var carryTouch: UITouch? = nil

    func isThirdHandObjectTouch(_ touch: UITouch) -> Bool {
        if let thirdHandGameObject = self.carryingGameObject,
           touch.is(onThe: thirdHandGameObject) {
            return true
        }

        return false
    }

    func carryTouchBegan(_ touch: UITouch) {
        self.carryTouch = touch
    }

    func carryTouchMoved(_ touch: UITouch) {
        self.thirdHand.position = touch.location(in: self.ui)
    }

    func carryTouchEnded(_ touch: UITouch) {
        if let touchedInventoryCell = self.inventory.inventoryCell(at: touch) {
            guard touchedInventoryCell.children.first == nil else {
                self.carryTouchCancelled(touch)
                return
            }

            let carryingGameObject = self.carryingGameObject!
            carryingGameObject.move(toParent: touchedInventoryCell)
            carryingGameObject.position = CGPoint()
            carryingGameObject.alpha = 1.0

            let tileCoordinate = TileCoordinate(x: touchedInventoryCell.firstIndexFromParent!, y: 0)
            let coordinate = GameObjectCoordinate(containerType: .inventory, tileCoordinate: tileCoordinate)
            self.sceneController.move(carryingGameObject, to: coordinate)

            self.carryTouchReset(touch)
            return
        }

        let characterTileCoordinate = TileCoordinate(self.characterPosition)
        let touchTileCoordinate = TileCoordinate(touch.location(in: worldLayer))
        if touchTileCoordinate.isAdjacent(coordinate: characterTileCoordinate) {
            guard self.gameObjectLayer.directChild(at: touch) == nil else {
                self.carryTouchCancelled(touch)
                return
            }

            let carryingGameObject = self.carryingGameObject!
            carryingGameObject.move(toParent: gameObjectLayer)
            // TODO: make function for calculate tile coordinate
            carryingGameObject.position = (touchTileCoordinate.toCGPoint() + 0.5) * Constant.tileSide
            carryingGameObject.alpha = 1.0

            let coordinate = GameObjectCoordinate(containerType: .field, tileCoordinate: touchTileCoordinate)
            self.sceneController.move(carryingGameObject, to: coordinate)

            self.carryTouchReset(touch)
            return
        }
    }

    func carryTouchCancelled(_ touch: UITouch) {
        self.carryTouchReset(touch)
    }

    func carryTouchReset(_ touch: UITouch) {
        self.carryTouch = nil
    }

    // MARK: - menu window touch
    func menuWindowTouchBegan(_ touch: UITouch) {
        // TODO: implement
    }

    func menuWindowTouchMoved(_ touch: UITouch) {
        // TODO: implement
    }

    func menuWindowTouchEnded(_ touch: UITouch) {
        let currentLocation = touch.location(in: self)
        if self.exitWorldButton.contains(currentLocation) {
            performSegueToPortalScene()
        } else {
            self.menuWindow.isHidden = true
        }

        self.menuWindowTouchReset(touch)
    }

    func menuWindowTouchCancelled(_ touch: UITouch) {
        self.menuWindowTouchReset(touch)
    }

    func menuWindowTouchReset(_ touch: UITouch) {
    }

    func performSegueToPortalScene() {
        self.sceneController.viewController.setPortalScene()
    }

    // MARK: - ovverride
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchBegan(touch) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchMoved(touch) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchEnded(touch) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchCancelled(touch) }
    }

    // MARK: - update scene
    var velocityVector = CGVector(dx: 0.0, dy: 0.0)
    var lastUpdateTime: TimeInterval = 0.0
    var lastPosition: CGPoint = CGPoint()

    override func update(_ currentTime: TimeInterval) {
        let timeInterval: TimeInterval = currentTime - lastUpdateTime

        self.characterPosition += self.velocityVector * timeInterval

        updateVelocity(timeInterval: timeInterval)

        updateAccessableGameObjects()
        resolveWorldBorderCollision()
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

        let accessableNodes = self.gameObjectLayer.directNodes(at: self.accessBox)
        let currentAccessableObjectCount = accessableNodes.count

        guard currentAccessableObjectCount != 0
                || self.accessableGameObjects.first != nil else { return }

        for index in 0..<self.accessableGameObjects.count {
            self.accessableGameObjects[index] = nil
        }

        // TODO: prevent force unwrap
        for (index, accessableNode) in accessableNodes.enumerated() {
            self.accessableGameObjects[index] = accessableNode as! GameObject?
        }
    }

    func resolveWorldBorderCollision() {
        self.characterPosition.x = characterPosition.x < Constant.moveableArea.minX
            ? Constant.moveableArea.minX
            : self.characterPosition.x
        self.characterPosition.x = characterPosition.x > Constant.moveableArea.maxX
            ? Constant.moveableArea.maxX
            : self.characterPosition.x
        self.characterPosition.y = characterPosition.y < Constant.moveableArea.minY
            ? Constant.moveableArea.minY
            : self.characterPosition.y
        self.characterPosition.y = characterPosition.y > Constant.moveableArea.maxY
            ? Constant.moveableArea.maxY
            : self.characterPosition.y
    }

    func resolveCollision() {
        for gameObject in self.accessableGameObjects {
            guard let gameObject = gameObject, !gameObject.isWalkable else { continue }

            if !gameObject.resolveSideCollisionPointWithCircle(ofOrigin: &self.characterPosition, andRadius: Constant.characterRadius) {
                gameObject.resolvePointCollisionPointWithCircle(ofOrigin: &self.characterPosition, andRadius: Constant.characterRadius)
            }
        }
    }

    // MARK: - edit
    func set(tileType: TileType, toX x: Int, y: Int) {
        self.tileMap.setTileGroup(tileType.tileGroup, andTileDefinition: tileType.tileDefinition, forColumn: y, row: x)
    }

    func add(by gameObjectMO: GameObjectMO) -> GameObject {
        let type = Resource.gameObjectTypeIDToInformation[Int(gameObjectMO.typeID)].type

        let texture = Resource.getTexture(of: type)
        let gameObject = type.init(texture: texture)

        gameObject.zPosition = 1.0

        switch gameObjectMO.containerType {
        case .field:
            gameObject.position = (gameObjectMO.position + 0.5) * Constant.defaultSize
            self.gameObjectLayer.addChild(gameObject)
        case .inventory:
            let inventoryIndex = Int(gameObjectMO.x)
            let inventoryCell = self.inventory.children.safeSubscrirpt(inventoryIndex)
            inventoryCell.addChild(gameObject)
        case .thirdHand:
            gameObject.alpha = 0.5
            self.thirdHand.addChild(gameObject)
        }

        return gameObject
    }

    // MARK: - etc
    func isMovedTile() -> Bool {
        let currentPosition = self.characterPosition

        let lastTile = TileCoordinate(self.lastPosition)
        let currentTile = TileCoordinate(currentPosition)

        return currentTile != lastTile
    }

}
