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
    var characterInv: InventoryWindow!
    var leftHandGO: GameObjectNode? { self.characterInv.leftHandGO }
    var rightHandGO: GameObjectNode? { self.characterInv.rightHandGO }

    // MARK: layer
    var movingLayer: MovingLayer!

    var ui: SKNode!
    var interactionZone: InteractionZone!
    var craftWindow: CraftWindow!

    var munuWindow: MenuWindow!
    var exitWorldButtonNode: SKNode!

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

        // MARK: fixed layer
        let fixedLayer = SKNode()
        fixedLayer.zPosition = Constant.ZPosition.fixedLayer
        self.addChild(fixedLayer)

        // MARK: character
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
                    radius: Constant.characterRadius,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        let character = SKShapeNode(path: path)
        character.fillColor = .white
        character.strokeColor = .brown
        character.lineWidth = 5.0
        character.position = Constant.sceneCenter
        character.zPosition = Constant.ZPosition.character

        fixedLayer.addChild(character)

        // MARK: ui
        let ui = SKNode()
        ui.zPosition = Constant.ZPosition.ui
        fixedLayer.addChild(ui)
        self.ui = ui

        let menuButtonNode: ButtonNode = ButtonNode(imageNamed: Constant.ResourceName.menuButtonNode)
        menuButtonNode.setUp()
        menuButtonNode.set(frame: Constant.Frame.menuButtonNode)
        menuButtonNode.delegate = self
        ui.addChild(menuButtonNode)

        let interactionZone = InteractionZone()
        interactionZone.setUp()
        ui.addChild(interactionZone)
        self.interactionZone = interactionZone

        let invWindow = InventoryWindow()
        invWindow.setUp()
        ui.addChild(invWindow)
        self.characterInv = invWindow

        let craftWindow = CraftWindow()
        craftWindow.setUp()
        ui.addChild(craftWindow)
        self.craftWindow = craftWindow

        let munuWindow = MenuWindow()
        munuWindow.setUp()
        ui.addChild(munuWindow)
        self.munuWindow = munuWindow
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
        self.craftWindow.update()

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

extension WorldScene: ButtonNodeDelegate {

    func buttonTapped(sender: Any?) {
        self.munuWindow.reveal()
    }

}
