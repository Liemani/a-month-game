//
//  WorldScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import SpriteKit
import GameplayKit

class WorldScene: SKScene, LMITouchResponder {

    var worldViewController: WorldViewController {
        return self.view!.next! as! WorldViewController
    }

    // MARK: manager
    var touchContextManager: WorldSceneTouchContextManager!
    var characterNodeMoveManager: CharacterNodeMoveManager!

    // MARK: view
    var containers: [(any Container)?]!

    var field: Field { self.containers[ContainerType.field] as! Field }

    var inventory: InventoryPane { self.containers[ContainerType.inventory] as! InventoryPane }
    var leftHandGO: GameObject? { self.inventory.leftHandGO }
    var rightHandGO: GameObject? { self.inventory.rightHandGO }

    var thirdHand: ThirdHand { self.containers[ContainerType.thirdHand] as! ThirdHand }
    var thirdHandGO: GameObject? { self.thirdHand.gameObject }

    // MARK: layer
    var movingLayer: MovingLayer!
    var tileMap: SKTileMapNode!

    var ui: SKNode!
    var interactionZone: InteractionZone!
    var craftPane: CraftPane!

    var menuPane: MenuPane!
    var exitWorldButton: SKNode!

    override init(size: CGSize) {
        super.init(size: size)

        self.touchContextManager = WorldSceneTouchContextManager()
        self.containers = [(any Container)?](repeating: nil, count: ContainerType.caseCount)

        self.initSceneLayer()
        self.initCharacterNodeMoveManager(scene: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - init scene layer
    func initSceneLayer() {
        self.containers.reserveCapacity(ContainerType.caseCount)

        self.scaleMode = .aspectFit

        self.addMovingLayer(to: self)
        self.addFixedLayer(to: self)
    }

    // MARK: add moving layer
    func addMovingLayer(to parent: SKNode) {
        let movingLayer = MovingLayer()

        parent.addChild(movingLayer)
        self.movingLayer = movingLayer

        self.containers[ContainerType.field] = movingLayer.field
        self.tileMap = movingLayer.tileMap
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

    // MARK: - init
    func initCharacterNodeMoveManager(scene: SKScene) {
        let moveManager = CharacterNodeMoveManager()

        moveManager.scene = self
        moveManager.character = self.movingLayer.character
        moveManager.movingLayer = self.movingLayer

        self.characterNodeMoveManager = moveManager
    }

    // MARK: - edit model

    func addGO(of goType: GameObjectType, to goCoord: GameObjectCoordinate) -> GameObject {
        let container = self.containers[goCoord.containerType]!
        let go = GameObject.new(of: goType)
        container.addGO(go, to: goCoord.coord)
        self.interactionZone.reserveUpdate()
        return go
    }

    // MARK: - set up
    func setUp(characterPosition: CGPoint) {
        self.characterNodeMoveManager.characterPosition = characterPosition
    }

    // MARK: - update
    var lastUpdateTime: TimeInterval = 0.0

    override func update(_ currentTime: TimeInterval) {
        let timeInterval: TimeInterval = currentTime - self.lastUpdateTime

        self.characterNodeMoveManager.update(timeInterval)
        self.worldViewController.update()
        self.interactionZone.update()
        self.craftPane.update()

        self.lastUpdateTime = currentTime

    }

    // MARK: - delegate
    func addGOMO(from go: GameObject, to goCoord: GameObjectCoordinate) {
        self.worldViewController.addGOMO(from: go, to: goCoord)
    }

    func addGOMO(of goType: GameObjectType, to goCoord: GameObjectCoordinate) {
        self.worldViewController.addGOMO(of: goType, to: goCoord)
    }

    func moveGOMO(from go: GameObject, to goCoord: GameObjectCoordinate) {
        self.worldViewController.moveGOMO(from: go, to: goCoord)
    }

    func removeGOMO(from gos: any Sequence<GameObject>) {
        self.worldViewController.removeGOMO(from: gos)
    }

    func removeGOMO(from go: GameObject) {
        self.worldViewController.removeGOMO(from: go)
    }

    // MARK: - touch
    func touchBegan(_ touch: UITouch) {
        self.characterNodeMoveManager.touchBegan(touch)
    }

    func touchMoved(_ touch: UITouch) {
        self.characterNodeMoveManager.touchMoved(touch)
    }

    func touchEnded(_ touch: UITouch) {
        self.characterNodeMoveManager.touchEnded(touch)
    }

    func touchCancelled(_ touch: UITouch) {
        self.characterNodeMoveManager.touchCancelled(touch)
    }

    func resetTouch(_ touch: UITouch) {
        self.characterNodeMoveManager.resetTouch(touch)
    }

    // MARK: - override
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

}

extension WorldScene: ButtonDelegate {

    func buttonTapped(sender: Any?) {
        self.menuPane.reveal()
    }

}
