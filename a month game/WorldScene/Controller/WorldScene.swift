//
//  WorldScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import SpriteKit
import GameplayKit

class WorldScene: SKScene {

    // MARK: model
    var worldSceneModel: WorldSceneModel!

    var goMOGO: GOMOGO!

    var touchManager: WorldSceneTouchManager!

    var character: CharacterModel!

    // MARK: view
    var containers: [(any Container)?]!

    var field: Field { self.containers[ContainerType.field] as! Field }

    var inventory: InventoryPane { self.containers[ContainerType.inventory] as! InventoryPane }
    var leftHandGO: GameObject? { self.inventory.leftHandGO }
    var rightHandGO: GameObject? { self.inventory.rightHandGO }

    var thirdHand: ThirdHand { self.containers[ContainerType.thirdHand] as! ThirdHand }
    var thirdHandGO: GameObject? { self.thirdHand.gameObject }

    // MARK: layer
    var movingLayer: SKNode!
    var worldLayer: SKNode!
    var tileMap: SKTileMapNode!

    var ui: SKNode!
    var interactionZone: InteractionZone!
    var craftPane: CraftPane!

    var menuPane: MenuPane!
    var exitWorldButton: SKNode!

    // MARK: - set up
    func setUp(worldName: String) {
        self.goMOGO = GOMOGO()
        self.touchManager = WorldSceneTouchManager()
        self.containers = [(any Container)?](repeating: nil, count: ContainerType.caseCount)

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
        self.addField(to: worldLayer)
    }

    func addTileMap(to parent: SKNode) {
        let tileGroups = TileType.tileGroups
        let tileSet = SKTileSet(tileGroups: tileGroups)

        let tileMap = SKTileMapNode(tileSet: tileSet, columns: Constant.gridSize, rows: Constant.gridSize, tileSize: Constant.tileTextureSize)
        tileMap.xScale = Constant.tileScale
        tileMap.yScale = Constant.tileScale

        tileMap.position = Constant.tileMapPosition
        tileMap.zPosition = Constant.ZPosition.tileMap

        parent.addChild(tileMap)
        self.tileMap = tileMap
    }

    func addField(to parent: SKNode) {
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
        self.addMenuPane(to: fixedLayer)
    }

    func addUI(to parent: SKNode) {
        let ui = SKNode()

        ui.zPosition = Constant.ZPosition.ui

        parent.addChild(ui)
        self.ui = ui

        self.addMenuButton(to: ui)
        self.addCharacter(to: ui)
        self.addInteractionZone(to: ui)
        self.addInventory(to: ui)
        self.addThirdHand(to: ui)
        self.addCraftPane(to: ui)
    }

    func addMenuButton(to parent: SKNode) {
        let menuButton: Button = Button(imageNamed: Constant.ResourceName.menuButton)
        menuButton.setUp()
        menuButton.set(frame: Constant.Frame.menuButton)
        menuButton.delegate = self

        parent.addChild(menuButton)
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

    func addInventory(to parent: SKNode) {
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

    func addMenuPane(to parent: SKNode) {
        let menuPane = MenuPane()
        menuPane.setUp()

        parent.addChild(menuPane)
        self.menuPane = menuPane
    }

    // MARK: set up model
    func setUpModel(worldName: String) {
        self.worldSceneModel = WorldSceneModel(worldScene: self, worldName: worldName)

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
        let goMOs = self.worldSceneModel.loadGOMOs()
        for goMO in goMOs {
            self.addGO(from: goMO)
        }
    }

    func setUpCharacter() {
        self.character = CharacterModel(worldScene: self)
    }

    // MARK: - update
    var lastUpdateTime: TimeInterval = 0.0

    override func update(_ currentTime: TimeInterval) {
        let timeInterval: TimeInterval = currentTime - self.lastUpdateTime

        self.character.update(timeInterval)
        self.worldSceneModel.contextSave()
        self.interactionZone.update()
        self.craftPane.update()

        self.lastUpdateTime = currentTime
    }

    // MARK: - edit model
    // MARK: - tile
    func set(tileType: TileType, toX x: Int, y: Int) {
        self.tileMap.setTileGroup(tileType.tileGroup, andTileDefinition: tileType.tileDefinition, forColumn: y, row: x)
    }

    // MARK: - game object
    private func addGO(of goType: GameObjectType, to goCoord: GameObjectCoordinate) -> GameObject {
        let container = self.containers[goCoord.containerType]!
        let go = GameObject.new(of: goType)
        container.addGO(go, to: goCoord.coord)
        self.interactionZone.reserveUpdate()
        return go
    }

    /// Called when loading GOMO from disk
    private func addGO(from goMO: GameObjectMO) {
        guard let containerType = goMO.containerType else { return }

        let container = self.containers[containerType]!
        let goMOCoord = goMO.coord

        if container.isValid(goMOCoord)
            , let go = GameObject.new(from: goMO) {
            container.addGO(go, to: goMOCoord)
            self.interactionZone.reserveUpdate()
            self.goMOGO[goMO] = go
        }
    }

    // MARK: - game object managed object
    func addGOMO(of goType: GameObjectType, to goCoord: GameObjectCoordinate) {
        let go = self.addGO(of: goType, to: goCoord)
        let goMO = self.worldSceneModel.newGOMO(of: goType, to: goCoord)
        self.goMOGO[goMO] = go
    }

    /// Add GOMO and move GO
    /// Called when craft, so don't need to update
    func addGOMO(from go: GameObject, to goCoord: GameObjectCoordinate) {
        self.containers[goCoord.containerType]!.moveGO(go, to: goCoord.coord)
        let goMO = self.worldSceneModel.newGOMO(of: go.type, to: goCoord)
        self.goMOGO[goMO] = go
    }

    func moveGOMO(from go: GameObject, to goCoord: GameObjectCoordinate) {
        let goMO = self.goMOGO[go]!
        self.worldSceneModel.setGOMO(goMO, to: goCoord)
        self.containers[goCoord.containerType]!.moveGO(go, to: goCoord.coord)
        self.interactionZone.reserveUpdate()
    }

    func removeGOMO(from go: GameObject) {
        let goMO = self.goMOGO.remove(go)!
        self.worldSceneModel.remove(goMO)
        go.removeFromParent()
        self.interactionZone.reserveUpdate()
    }

    // TODO: check this method, other edit is perfect
    func removeGOMO(from gos: any Sequence<GameObject>) {
        for go in gos {
            let go = go as! GameObject
            let goMO = self.goMOGO.remove(go)!
            self.worldSceneModel.remove(goMO)
            go.removeFromParent()
        }
        self.interactionZone.reserveUpdate()
    }

}

extension WorldScene: ButtonDelegate {

    func buttonTapped(sender: Any?) {
        self.menuPane.reveal()
    }

}
