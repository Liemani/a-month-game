//
//  WorldScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import SpriteKit
import GameplayKit

class WorldScene: SKScene {

    weak var viewController: ViewController!

    // MARK: model
    var worldSceneModel: WorldSceneModel!

    var goMOGO: GOMOGO = GOMOGO()

    var touchManager: WorldSceneTouchManager = WorldSceneTouchManager()

    // MARK: view
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
        get { -self.movingLayer.position }
        set { self.movingLayer.position = -newValue }
    }

    // MARK: - set up
    func setUp(viewController: ViewController, worldName: String) {
        self.viewController = viewController

        self.setUpSceneLayer()
        self.setUpModel(worldName: worldName)

        #if DEBUG
        self.debugCode()
        #endif
    }

#if DEBUG
    func debugCode() {
        for goMO in self.goMOGO.goMOs {
            print("id: \(goMO.id), typeID: \(goMO.typeID), containerID: \(goMO.containerID), coordinate: (\(goMO.x), \(goMO.y))")
        }
    }
#endif

    func setUpSceneLayer() {
        self.containers.reserveCapacity(ContainerType.caseCount)

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

    // MARK: set up model
    func setUpModel(worldName: String) {
        self.worldSceneModel = WorldSceneModel(worldSceneController: self, worldName: worldName)

        self.setUpTile()
        self.setUpGOMOs()
        self.setUpCharacter()
    }

    func setUpTile() {
        let tileModel: TileMapModel = self.worldSceneModel.tileMapModel
        for x in 0..<Constant.gridSize {
            for y in 0..<Constant.gridSize {
                let tileType = tileModel.tileType(atX: x, y: y)
                self.set(tileType: tileType, toX: x, y: y)
            }
        }
    }

    func setUpGOMOs() {
        let goMOs = self.worldSceneModel.loadGOs()
        self.addGOs(goMOs)
    }

    func setUpCharacter() {
        let characterPosition = self.worldSceneModel.characterModel.position
        self.characterPosition = characterPosition
    }

    // MARK: - touch
    override func touchBegan(_ touch: UITouch) {
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
    }

    override func touchMoved(_ touch: UITouch) {
        if self.isMenuOpen {
            self.menuWindowTouchMoved(touch)
            return
        }

        switch touch {
        case self.menuButtonTouch:
            self.menuButtonTouchMoved(touch)
        case self.craftObjectTouch:
            self.craftObjectTouchMoved(touch)
        default: break
        }
    }

    override func touchEnded(_ touch: UITouch) {
        if self.isMenuOpen {
            self.menuWindowTouchEnded(touch)
            return
        }

        switch touch {
        case self.menuButtonTouch:
            self.menuButtonTouchEnded(touch)
        case self.craftObjectTouch:
            self.craftObjectTouchEnded(touch)
        default: break
        }
    }

    override func touchCancelled(_ touch: UITouch) {
        if self.isMenuOpen {
            self.menuWindowTouchCancelled(touch)
            return
        }

        switch touch {
        case self.menuButtonTouch:
            self.menuButtonTouchCancelled(touch)
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
            self.touchManager.cancel(of: FieldTouch.self)
            self.touchManager.cancel(of: GameObjectTouch.self)
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

    // MARK: - set velocity
    func setVelocityVector() {
        let fieldTouch = self.touchManager.first(of: FieldTouch.self) as! FieldTouch

        guard let previousPreviousLocation = fieldTouch.previousPreviousLocation else {
            return
        }

        let previousLocation = fieldTouch.uiTouch.previousLocation(in: self)
        let timeInterval = fieldTouch.previousTimestamp - fieldTouch.previousPreviousTimestamp

        self.velocityVector = -(previousLocation - previousPreviousLocation) / timeInterval
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
        self.viewController.setPortalScene()
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

    // MARK: - edit model
    // MARK: - tile
    func set(tileType: TileType, toX x: Int, y: Int) {
        self.tileMap.setTileGroup(tileType.tileGroup, andTileDefinition: tileType.tileDefinition, forColumn: y, row: x)
    }

    // MARK: - game object
    /// Must called at controller
    func addGO(from goMO: GameObjectMO) -> GameObject? {
        guard let containerType = goMO.containerType else {
            return nil
        }

        let container = self.containers[containerType]

        guard container.isVaid(goMO.coordinate),
              let go = GameObjectType.new(typeID: goMO.typeID) else {
            return nil
        }

        container.addGO(go, to: goMO.coordinate)

        return go
    }

    // MARK: - game object managed object
    /// Save the context manually
    /// Apply scene gos change manually
    func addGOMO(gameObjectType goType: GameObjectType, goCoord: GameObjectCoordinate) {
        let goMO = self.worldSceneModel.newGOMO(gameObjectType: goType, goCoord: goCoord)
        if let go = self.addGO(from: goMO) {
            self.goMOGO[goMO] = go
        }
    }

    func addGOs(_ goMOs: [GameObjectMO]) {
        for goMO in goMOs {
            if let go = self.addGO(from: goMO) {
                self.goMOGO[goMO] = go
            }
        }
        self.interactionZone.update()
    }

    // MARK: move
    func moveGOMO(from go: GameObject, to goCoord: GameObjectCoordinate) {
        let goMO = self.goMOGO[go]!
        goMO.set(goCoord: goCoord)
        self.worldSceneModel.contextSave()

        self.containers[goCoord.containerType].moveGO(go, to: goCoord.coord)
    }

    // MARK: remove
    func removeGOMO(from gos: [GameObject]) {
        for go in gos {
            let goMO = self.goMOGO.remove(go)!
            self.worldSceneModel.remove(goMO)
            go.removeFromParent()
        }
        self.worldSceneModel.contextSave()
        self.interactionZone.update()
    }

    // MARK: - etc
    func isTileChanged() -> Bool {
        let currentPosition = self.characterPosition

        let lastTile = TileCoordinate(from: self.lastPosition)
        let currentTile = TileCoordinate(from: currentPosition)

        return currentTile != lastTile
    }

    /// - Returns: Return value is bit flag describing Nth space of clockwise order is possessed.
    func spareDirections(_ lhGOMO: GameObjectMO) -> [Coordinate<Int>] {
        var occupySpaceBitFlags: UInt8 = 0

        let spaceShiftTable: [UInt8] = Constant.spaceShiftTable

        let lhGOMOCoord = lhGOMO.coordinate
        for rhGOMO in self.goMOGO.goMOsInField {
            let rhGOMOCoord = rhGOMO.coordinate
            if lhGOMOCoord.isAdjacent(to: rhGOMOCoord) {
                let differenceX = rhGOMOCoord.x - lhGOMOCoord.x
                let differenceY = rhGOMOCoord.y - lhGOMOCoord.y
                let tableIndex = (differenceY - 1) * -3 + (differenceX + 1)
                occupySpaceBitFlags |= 0x1 << spaceShiftTable[tableIndex]
            }
        }

        let coordVectorTable = Constant.coordVectorTable

        var spareSpaces: [Coordinate<Int>] = []

        for index in 0..<8 {
            if (occupySpaceBitFlags >> index) & 0x1 == 0x0 {
                spareSpaces.append(coordVectorTable[index])
            }
        }

        return spareSpaces
    }

    // MARK: - interact
    func interact(_ go: GameObject) {
        guard go.parent is Field else {
            return
        }

        switch go.type {
        case .pineTree:
            guard Double.random(in: 0.0...1.0) <= 0.33 else {
                return
            }

            let goMO = self.goMOGO.field[go]!
            let spareDirections = self.spareDirections(goMO)

            guard !spareDirections.isEmpty else {
                return
            }

            let coordToAdd = spareDirections[Int.random(in: 0..<spareDirections.count)]
            let newGOMOCoord = goMO.coordinate + coordToAdd

            let goType = GameObjectType.branch
            let goCoord = GameObjectCoordinate(containerType: .field, x: newGOMOCoord.x, y: newGOMOCoord.y)

            self.addGOMO(gameObjectType: goType, goCoord: goCoord)
            self.worldSceneModel.contextSave()
            self.interactionZone.update()
        default: break
        }
    }

}
