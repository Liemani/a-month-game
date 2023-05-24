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

    var containerArray: [ContainerNode?] = [ContainerNode?].init(repeating: nil, count: ContainerType.caseCount)

    var field: FieldNode {
        return self.containerArray[ContainerType.field] as! FieldNode
    }

    var inventory: InventoryNode {
        return self.containerArray[ContainerType.inventory] as! InventoryNode
    }

    var thirdHand: ThirdHandNode {
        return self.containerArray[ContainerType.thirdHand] as! ThirdHandNode
    }

    var movingLayer: SKNode!
    var worldLayer: SKNode!
    var tileMap: SKTileMapNode!

    var ui: SKNode!
    var menuButton: SKNode!
    var accessBox: SKNode!

    var leftHandGO: GameObject? {
        return self.inventory.leftHandGO
    }

    var rightHandGO: GameObject? {
        return self.inventory.rightHandGO
    }

    var carryingGO: GameObject? {
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

    var accessableGOs = [GameObject?](repeating: nil, count: 9)

    // MARK: - initialize
    func setUp(sceneController: WorldSceneController) {
        self.sceneController = sceneController

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
        self.fieldNode(to: worldLayer)
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

    func fieldNode(to parent: SKNode) {
        let field = FieldNode()

        field.zPosition = Constant.ZPosition.gameObjectLayer

        parent.addChild(field)
        self.containerArray[ContainerType.field] = field
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
        self.addCharacterInventory(to: ui)
        self.addThirdHand(to: ui)
    }

    func addMenuButton(to parent: SKNode) {
        let menuButton: SKSpriteNode = SKSpriteNode(imageNamed: Constant.ResourceName.menuButton)

        menuButton.position = Constant.Frame.menuButton.origin
        menuButton.size = Constant.Frame.menuButton.size

        parent.addChild(menuButton)
        self.menuButton = menuButton
    }

    func addCharacter(to parent: SKNode) {
        let character: SKSpriteNode = SKSpriteNode(imageNamed: Constant.ResourceName.character)

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

    func addCharacterInventory(to parent: SKNode) {
        let characterInventory = InventoryNode()
        characterInventory.setUp()

        parent.addChild(characterInventory)
        self.containerArray[ContainerType.inventory] = characterInventory
    }

    func addThirdHand(to parent: SKNode) {
        let thirdHand = ThirdHandNode()

        thirdHand.position = Constant.sceneCenter

        parent.addChild(thirdHand)
        self.containerArray[ContainerType.thirdHand] = thirdHand
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

        let buttonTexture = SKTexture(imageNamed: Constant.ResourceName.button)
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

        if self.isFieldGOTouched(touch) {
            self.gameObjectTouchBegan(touch)
            return
        }

        if self.isInventoryGOTouched(touch) {
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
    var touchedGO: GameObject? = nil

    func isFieldGOTouched(_ touch: UITouch) -> Bool {
        if let go = self.field.gameObject(at: touch),
           self.accessableGOs.contains(go) {
            self.touchedGO = go
            return true
        }

        return false
    }

    func isInventoryGOTouched(_ touch: UITouch) -> Bool {
        if let go = self.inventory.gameObject(at: touch) {
            self.touchedGO = go
            return true
        }

        return false
    }

    func gameObjectTouchBegan(_ touch: UITouch) {
        self.gameObjectTouch = touch
        self.touchedGO!.alpha = 0.5
    }

    func gameObjectTouchMoved(_ touch: UITouch) {
        if !touch.is(onThe: self.touchedGO!) {
            if self.carryingGO == nil && self.touchedGO!.isPickable {
                self.thirdHand.position = touch.location(in: self.ui)
                self.touchedGO!.move(toParent: self.thirdHand)
                self.touchedGO!.position = CGPoint()
                let coordinate = GameObjectCoordinate(containerType: ContainerType.thirdHand, x: 0, y: 0)
                self.sceneController.move(self.touchedGO!, to: coordinate)

                self.gameObjectTouchReset(touch)
                self.carryTouchBegan(touch)
            } else {
                self.gameObjectTouchCancelled(touch)
            }
        }
    }

    func gameObjectTouchEnded(_ touch: UITouch) {
        self.sceneController.interact(self.touchedGO!, leftHand: self.leftHandGO, rightHand: self.rightHandGO)
        self.touchedGO!.alpha = 1.0

        self.gameObjectTouchReset(touch)
    }

    func gameObjectTouchCancelled(_ touch: UITouch) {
        self.touchedGO?.alpha = 1.0

        self.gameObjectTouchReset(touch)
    }

    func gameObjectTouchReset(_ touch: UITouch) {
        self.gameObjectTouch = nil
        self.touchedGO = nil
    }

    // MARK: - carry touch
    var carryTouch: UITouch? = nil

    func isThirdHandObjectTouch(_ touch: UITouch) -> Bool {
        if let thirdHandGO = self.carryingGO,
           touch.is(onThe: thirdHandGO) {
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

            let carryingGO = self.carryingGO!
            carryingGO.move(toParent: touchedInventoryCell)
            carryingGO.position = CGPoint()
            carryingGO.alpha = 1.0

            let coordinate = Coordinate(touchedInventoryCell.firstIndexFromParent!, 0)
            let goCoordinate = GameObjectCoordinate(containerType: ContainerType.inventory, coordinate: coordinate)
            self.move(carryingGO, to: goCoordinate)

            self.carryTouchReset(touch)
            return
        }

        let characterTC = TileCoordinate(from: self.characterPosition)
        let touchedTC = TileCoordinate(from: touch.location(in: worldLayer))
        guard touchedTC.isAdjacent(with: characterTC) else {
            return
        }

        guard self.field.gameObject(at: touch) == nil else {
            self.carryTouchCancelled(touch)
            return
        }

        let carryingGO = self.carryingGO!
        carryingGO.move(toParent: self.field)
        carryingGO.position = touchedTC.fieldPoint
        carryingGO.alpha = 1.0

        self.addAccessableGO(carryingGO)

        let coordinate = GameObjectCoordinate(containerType: ContainerType.field, coordinate: touchedTC.value)
        self.sceneController.move(carryingGO, to: coordinate)

        self.carryTouchReset(touch)
        return
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
        let timeInterval: TimeInterval = currentTime - self.lastUpdateTime

        self.characterPosition += self.velocityVector * timeInterval

        self.updateVelocity(timeInterval: timeInterval)

        self.updateAccessableGOs()
        self.resolveWorldBorderCollision()
        self.resolveCollision()

        self.lastUpdateTime = currentTime
        self.lastPosition = self.characterPosition
    }

    func updateVelocity(timeInterval: TimeInterval) {
        let velocity = self.velocityVector.magnitude
        self.velocityVector =
            velocity <= Constant.velocityDamping
            ? CGVectorMake(0.0, 0.0)
            : self.velocityVector * pow(Constant.velocityFrictionRatioPerSec, timeInterval)
    }

    // MARK: accessable go
    func updateAccessableGOs() {
        guard self.isChangedTile() else { return }

        let accessableNodes = self.field.gameObjects(at: self.accessBox)
        let currentAccessableObjectCount = accessableNodes.count

        guard currentAccessableObjectCount != 0
                || self.accessableGOs.first != nil else { return }

        for index in 0..<self.accessableGOs.count {
            self.accessableGOs[index] = nil
        }

        for (index, accessableNode) in accessableNodes.enumerated() {
            self.accessableGOs[index] = accessableNode
        }
    }

    // MARK: resolve collision
    func resolveWorldBorderCollision() {
        self.characterPosition.x = self.characterPosition.x < Constant.moveableArea.minX
            ? Constant.moveableArea.minX
            : self.characterPosition.x
        self.characterPosition.x = self.characterPosition.x > Constant.moveableArea.maxX
            ? Constant.moveableArea.maxX
            : self.characterPosition.x
        self.characterPosition.y = self.characterPosition.y < Constant.moveableArea.minY
            ? Constant.moveableArea.minY
            : self.characterPosition.y
        self.characterPosition.y = self.characterPosition.y > Constant.moveableArea.maxY
            ? Constant.moveableArea.maxY
            : self.characterPosition.y
    }

    func resolveCollision() {
        for go in self.accessableGOs {
            guard let go = go, !go.isWalkable else { continue }

            if !go.resolveSideCollisionPointWithCircle(ofOrigin: &self.characterPosition, andRadius: Constant.characterRadius) {
                go.resolvePointCollisionPointWithCircle(ofOrigin: &self.characterPosition, andRadius: Constant.characterRadius)
            }
        }
    }

    // MARK: - edit
    func set(tileType: TileType, toX x: Int, y: Int) {
        self.tileMap.setTileGroup(tileType.tileGroup, andTileDefinition: tileType.tileDefinition, forColumn: y, row: x)
    }

    func add(by goMO: GameObjectMO) -> GameObject? {
        guard let containerType = goMO.containerType else { return nil }

        let go = self.containerArray[containerType]!.add(by: goMO)

        return go
    }

    func move(_ go: GameObject, to goCoordinate: GameObjectCoordinate) {
        self.sceneController.move(go, to: goCoordinate)
    }

    // MARK: - etc
    func isChangedTile() -> Bool {
        let currentPosition = self.characterPosition

        let lastTile = TileCoordinate(from: self.lastPosition)
        let currentTile = TileCoordinate(from: currentPosition)

        return currentTile != lastTile
    }

    func addAccessableGO(_ go: GameObject) {
        for (index, accessableGO) in self.accessableGOs.enumerated() {
            if accessableGO == nil {
                self.accessableGOs[index] = go
                return
            }
        }
    }

}
