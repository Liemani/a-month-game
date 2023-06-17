//
//  WorldScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import SpriteKit
import GameplayKit

class WorldScene: SKScene, LMITouchResponder {

    var worldViewController: WorldSceneViewController {
        return self.view!.next! as! WorldSceneViewController
    }

    var viewModel: WorldSceneViewModel!

    // MARK: manager
    var touchContextManager: WorldSceneTouchContextManager!
    var characterNodeMoveManager: CharacterNodeMoveManager!

    // MARK: view
    var field: FieldNode!

    var characterInv: InventoryPane!
    var leftHandGO: GameObjectNode? { self.characterInv.leftHandGO }
    var rightHandGO: GameObjectNode? { self.characterInv.rightHandGO }

    // MARK: layer
    var movingLayer: MovingLayer!
    var tileMap: SKTileMapNode!

    var ui: SKNode!
    var interactionZone: InteractionZone!
    var craftPane: CraftPane!

    var menuPane: MenuPane!
    var exitWorldButton: SKNode!

    /// initialize with size
    override init(size: CGSize) {
        super.init(size: size)

        self.scaleMode = .aspectFit

        self.touchContextManager = WorldSceneTouchContextManager()

        self.initSceneLayer()

        self.characterNodeMoveManager = CharacterNodeMoveManager(worldScene: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - init scene layer
    func initSceneLayer() {
        // MARK: moving layer
        let movingLayer = MovingLayer()
        self.addChild(movingLayer)
        self.movingLayer = movingLayer

        self.field = movingLayer.field
        self.tileMap = movingLayer.tileMap

        // MARK: fixed layer
        let fixedLayer = SKNode()
        fixedLayer.zPosition = Constant.ZPosition.fixedLayer
        self.addChild(fixedLayer)

        let ui = SKNode()
        ui.zPosition = Constant.ZPosition.ui
        fixedLayer.addChild(ui)
        self.ui = ui

        let menuButton: Button = Button(imageNamed: Constant.ResourceName.menuButton)
        menuButton.setUp()
        menuButton.set(frame: Constant.Frame.menuButton)
        menuButton.delegate = self
        ui.addChild(menuButton)

        let interactionZone = InteractionZone()
        interactionZone.setUp()
        ui.addChild(interactionZone)
        self.interactionZone = interactionZone

        let inventoryPane = InventoryPane()
        inventoryPane.setUp()
        ui.addChild(inventoryPane)
        self.characterInv = inventoryPane

        let craftPane = CraftPane()
        craftPane.setUp()
        ui.addChild(craftPane)
        self.craftPane = craftPane

        let menuPane = MenuPane()
        menuPane.setUp()
        ui.addChild(menuPane)
        self.menuPane = menuPane
    }

    // MARK: - edit model

//    func addGO(of goType: GameObjectType, to goCoord: GameObjectCoordinate) -> GameObjectNode {
//        let container = self.containers[goCoord.containerType]!
//        let go = GameObjectNode.new(of: goType)
//        container.addGO(go, to: goCoord.coord)
//        self.interactionZone.reserveUpdate()
//        return go
//    }

    // MARK: - update
    var lastUpdateTime: TimeInterval = 0.0

    override func update(_ currentTime: TimeInterval) {
        let timeInterval: TimeInterval = currentTime - self.lastUpdateTime

        self.worldViewController.update()

        self.characterNodeMoveManager.update(timeInterval)
        self.worldViewController.update()
        self.interactionZone.update()
        self.craftPane.update()

        self.lastUpdateTime = currentTime

    }

    // MARK: - delegate
//    func addGOMO(from go: GameObjectNode, to goCoord: GameObjectCoordinate) {
//        self.worldViewController.addGOMO(from: go, to: goCoord)
//    }
//
//    func addGOMO(of goType: GameObjectType, to goCoord: GameObjectCoordinate) {
//        self.worldViewController.addGOMO(of: goType, to: goCoord)
//    }
//
//    func moveGOMO(from go: GameObjectNode, to goCoord: GameObjectCoordinate) {
//        self.worldViewController.moveGOMO(from: go, to: goCoord)
//    }

    func remove(from gos: any Sequence<GameObjectNode>) {
        self.worldViewController.remove(from: gos)
    }

//    func removeGOMO(from go: GameObjectNode) {
//        self.worldViewController.removeGOMO(from: go)
//    }

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
