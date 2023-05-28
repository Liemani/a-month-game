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

    // MARK: container
    var containers: [ContainerNode] = [ContainerNode](repeating: ThirdHand(), count: ContainerType.caseCount)

    var field: Field { self.containers[ContainerType.field] as! Field }

    var inventory: InventoryPane { self.containers[ContainerType.inventory] as! InventoryPane }
    var leftHandGO: GameObject? { self.inventory.leftHandGO }
    var rightHandGO: GameObject? { self.inventory.rightHandGO }

    var thirdHand: ThirdHand { self.containers[ContainerType.thirdHand] as! ThirdHand }

    // MARK: layer
    var movingLayer: SKNode!
    var worldLayer: SKNode!
    var tileMap: SKTileMapNode!

    var ui: SKNode!
    var menuButton: SKNode!
    var interactionZone: InteractionZone!
    var craftPane: CraftPane!

    var menuWindow: SKNode!
    var exitWorldButton: SKNode!

    var isMenuOpen: Bool { return !menuWindow.isHidden }

    var characterPosition: CGPoint {
        get { return -self.movingLayer.position }
        set { self.movingLayer.position = -newValue }
    }

    // MARK: touch
    var progressingTouch: [Touch?] = [Touch?](repeating: nil, count: 2)

    // TODO: move
    func add(_ touch: Touch) -> Bool {
        if self.progressingTouch[0] == nil {
            self.progressingTouch[0] = touch
        } else if self.progressingTouch[1] == nil {
            self.progressingTouch[1] = touch
        } else {
            return false
        }

        return true
    }

    func containsTouch(from touch: UITouch) -> Bool {
        return self.progressingTouch[0]?.touch == touch
            || self.progressingTouch[1]?.touch == touch
    }

    func removeTouch(from touch: UITouch) {
        if self.progressingTouch[0]?.touch == touch {
            self.progressingTouch[0] = nil
        } else if self.progressingTouch[1]?.touch == touch {
            self.progressingTouch[1] = nil
        }
    }

    // MARK: - set up
    func setUp(sceneController: WorldSceneController) {
        self.containers.reserveCapacity(ContainerType.caseCount)

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
        self.field(to: worldLayer)
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

    func field(to parent: SKNode) {
        let field = Field()
        field.setUp()

        parent.addChild(field)
        self.containers[ContainerType.field] = field
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
        self.addInteractionZone(to: ui)
        self.addCharacterInventory(to: ui)
        self.addThirdHand(to: ui)
        self.addCraftPane(to: ui)
    }

    func addMenuButton(to parent: SKNode) {
        let menuButton: SKSpriteNode = SKSpriteNode(imageNamed: Constant.ResourceName.menuButton)

        menuButton.position = Constant.Frame.menuButton.origin
        menuButton.size = Constant.Frame.menuButton.size

        parent.addChild(menuButton)
        self.menuButton = menuButton
    }

    func addCharacter(to parent: SKNode) {
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
                    radius: Constant.characterRadius,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        let character = SKShapeNode(path: path)
        character.fillColor = .white
        character.strokeColor = .brown
        character.lineWidth = 10.0
        character.position = Constant.Frame.character.origin

        parent.addChild(character)
    }

    func addInteractionZone(to parent: SKNode) {
        let interactionZone = InteractionZone()
        interactionZone.setUp()

        parent.addChild(interactionZone)
        self.interactionZone = interactionZone
    }

    func addCharacterInventory(to parent: SKNode) {
        let inventoryPane = InventoryPane()
        inventoryPane.setUp()

        parent.addChild(inventoryPane)
        self.containers[ContainerType.inventory] = inventoryPane
    }

    func addThirdHand(to parent: SKNode) {
        let thirdHand = ThirdHand()
        thirdHand.position = Constant.sceneCenter
        thirdHand.zPosition = Constant.ZPosition.thirdHand

        parent.addChild(thirdHand)
        self.containers[ContainerType.thirdHand] = thirdHand
    }

    func addCraftPane(to parent: SKNode) {
        let craftPane = CraftPane()
        craftPane.setUp()

        parent.addChild(craftPane)
        self.craftPane = craftPane
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

        if self.isCraftObjectTouched(touch) {
            self.craftObjectTouchBegan(touch)
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
        case self.moveTouch:
            self.moveTouchMoved(touch)
        case self.craftObjectTouch:
            self.craftObjectTouchMoved(touch)
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
        case self.moveTouch:
            self.moveTouchEnded(touch)
        case self.craftObjectTouch:
            self.craftObjectTouchEnded(touch)
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
        case self.moveTouch:
            self.moveTouchCancelled(touch)
        case self.craftObjectTouch:
            self.craftObjectTouchCancelled(touch)
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
            for progressingTouch in self.progressingTouch {
                if let progressingTouch = progressingTouch as? GameObjectTouch {
                    progressingTouch.touchedGO.touchCancelled(touch)
                }
            }
        }
        self.resetMenuButtonTouch(touch)
    }

    func menuButtonTouchCancelled(_ touch: UITouch) {
        self.resetMenuButtonTouch(touch)
    }

    func resetMenuButtonTouch(_ touch: UITouch) {
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

        self.resetMoveTouch()
    }

    func moveTouchCancelled(_ touch: UITouch) {
        self.resetMoveTouch()
    }

    func resetMoveTouch() {
        self.moveTouch = nil
    }

    func setVelocityVector() {
        guard let previousLocation2 = self.previousMoveTouchLocation2 else { return }
        let previousLocation1 = self.moveTouch!.previousLocation(in: self)
        let timeInterval = self.previousMoveTouchTimestamp1 - self.previousMoveTouchTimestamp2

        self.velocityVector = -(previousLocation1 - previousLocation2) / timeInterval
    }

    // MARK: - craft object touch
    var craftObjectTouch: UITouch? = nil
    var touchedCraftObject: CraftObject? = nil

    func isCraftObjectTouched(_ touch: UITouch) -> Bool {
        if let touchedCraftObject = self.craftPane.craftObject(at: touch) {
            self.touchedCraftObject = touchedCraftObject
            return true
        }

        return false
    }

    func craftObjectTouchBegan(_ touch: UITouch) {
        self.craftObjectTouch = touch
    }

    func craftObjectTouchMoved(_ touch: UITouch) {
        guard !touch.is(onThe: self.touchedCraftObject!) else {
            return
        }

        self.craft()

        self.craftObjectTouchEnded(touch)
    }

    func craft() {
        // TODO: add remove ingredient game object
//        let recipe = getRecipe()

//        let goType = touchedCraftObject!.gameObjectType
//        let containerType = ContainerType.thirdHand
//        let x = 0
//        let y = 0

        print("crafted something")

    }

    func craftObjectTouchEnded(_ touch: UITouch) {
        self.touchedCraftObject!.deactivate()

        self.resetCraftObjectTouch()
    }

    func craftObjectTouchCancelled(_ touch: UITouch) {
        self.touchedCraftObject!.deactivate()

        self.resetCraftObjectTouch()
    }

    func resetCraftObjectTouch() {
        self.craftObjectTouch = nil
        self.touchedCraftObject = nil
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

        self.resetMenuWindowTouch(touch)
    }

    func menuWindowTouchCancelled(_ touch: UITouch) {
        self.resetMenuWindowTouch(touch)
    }

    func resetMenuWindowTouch(_ touch: UITouch) {
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

        if self.isTileChanged() {
            self.interactionZone.update()
        }

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

    // MARK: - resolve collision
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
        for go in self.interactionZone.gos {
            guard !go.isWalkable else { continue }

            if !go.resolveSideCollisionPointWithCircle(ofOrigin: &self.characterPosition, andRadius: Constant.characterRadius) {
                go.resolvePointCollisionPointWithCircle(ofOrigin: &self.characterPosition, andRadius: Constant.characterRadius)
            }
        }
    }

    // MARK: - edit
    func set(tileType: TileType, toX x: Int, y: Int) {
        self.tileMap.setTileGroup(tileType.tileGroup, andTileDefinition: tileType.tileDefinition, forColumn: y, row: x)
    }

    func isValid(_ goCoord: GameObjectCoordinate) -> Bool {
        return self.containers[goCoord.containerType].isVaid(goCoord.coord)
    }

    /// Must called at controller
    func addGO(from goMO: GameObjectMO) -> GameObject? {
        guard let containerType = goMO.containerType else {
            return nil
        }

        let container = self.containers[containerType]

        guard container.isVaid(goMO.coordinate) else {
            return nil
        }

        guard let go = GameObjectType.new(typeID: goMO.typeID) else {
            return nil
        }

        container.addGO(go, to: goMO.coordinate)

        return go
    }

    func moveGO(_ go: GameObject, to goCoord: GameObjectCoordinate) {
        let containerType = goCoord.containerType

        self.containers[containerType].moveGO(go, to: goCoord.coord)
    }

    func removeGO(_ gos: [GameObject]) {
        for go in gos {
            go.removeFromParent()
        }
        self.interactionZone.applyUpdate()
    }

    // MARK: - delegate
    func moveGOMO(from go: GameObject, to goCoord: GameObjectCoordinate) {
        self.sceneController.moveGOMO(from: go, to: goCoord)
    }

    // MARK: - etc
    func isTileChanged() -> Bool {
        let currentPosition = self.characterPosition

        let lastTile = TileCoordinate(from: self.lastPosition)
        let currentTile = TileCoordinate(from: currentPosition)

        return currentTile != lastTile
    }

    func interact(_ go: GameObject) {
        self.sceneController.interact(go, leftHand: self.leftHandGO, rightHand: self.rightHandGO)
    }

}
