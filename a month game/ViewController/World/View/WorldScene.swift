//
//  WorldScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import SpriteKit
import GameplayKit

class WorldScene: SKScene, TouchResponder {

    var worldViewController: WorldViewController {
        return self.view!.next! as! WorldViewController
    }

    // MARK: view
    var characterInv: CharacterInventory!
    var leftHandGO: GameObject? { self.characterInv.leftHandGO }
    var rightHandGO: GameObject? { self.characterInv.rightHandGO }

    // MARK: layer
    var movingLayer: MovingLayer!

    var character: Character!
    var ui: SKNode!
    var craftWindow: CraftWindow!

    var munuWindow: MenuWindow!
    var exitWorldButtonNode: SKNode!

    // MARK: - init
    /// initialize with size
    override init(size: CGSize) {
        super.init(size: size)

        self.scaleMode = .aspectFit

        self.initSceneLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initSceneLayer() {
        let worldLayer = SKNode()
        worldLayer.xScale = Constant.sceneScale
        worldLayer.yScale = Constant.sceneScale
        worldLayer.position = Constant.sceneCenter
        worldLayer.zPosition = Constant.ZPosition.worldLayer
        self.addChild(worldLayer)

        // MARK: moving layer
        let movingLayer = MovingLayer()
        worldLayer.addChild(movingLayer)
        self.movingLayer = movingLayer

        let character = Character()
        worldLayer.addChild(character)
        self.character = character

        // MARK: fixed layer
        let fixedLayer = SKNode()
        fixedLayer.zPosition = Constant.ZPosition.fixedLayer
        self.addChild(fixedLayer)

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

        let invWindow = CharacterInventory()
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
        self.handleTouchBeganEvent()

        let timeInterval = currentTime - self.lastUpdateTime

        self.worldViewController.update(timeInterval)

        self.lastUpdateTime = currentTime
    }

    func handleTouchBeganEvent() {
        while let event = TouchBeganEventManager.default.dequeue() {
            switch event.type {
            case .character:
                let handler = CharacterMoveTouchEventHandler(
                    touch: event.touch,
                    worldScene: self,
                    character: self.character)
                if TouchEventHandlerManager.default.add(handler) {
                    handler.touchBegan()
                }
            case .gameObject:
                let handler = GameObjectTouchEventHandler(
                    touch: event.touch,
                    go: event.sender as! GameObject)
                if TouchEventHandlerManager.default.add(handler) {
                    handler.touchBegan()
                }
            case .gameObjectMove:
                let handler = GameObjectMoveTouchEventHandler(
                    touch: event.touch,
                    go: event.sender as! GameObject)
                if TouchEventHandlerManager.default.add(handler) {
                    handler.touchBegan()
                }
            }
        }
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

    func remove(from gos: any Sequence<GameObject>) {
        self.worldViewController.remove(from: gos)
    }

//    func removeGOMO(from go: GameObjectNode) {
//        self.worldViewController.removeGOMO(from: go)
//    }

    // MARK: - touch
    func touchBegan(_ touch: UITouch) {
        TouchEventHandlerManager.default.cancelAll(of: CharacterMoveTouchEventHandler.self)

        let event = TouchBeganEvent(type: .character,
                                    touch: touch,
                                    sender: self)
        TouchBeganEventManager.default.enqueue(event)
    }

    func touchMoved(_ touch: UITouch) {
        guard let handler = TouchEventHandlerManager.default.handler(from: touch) else {
            return
        }

        handler.touchMoved()
    }

    func touchEnded(_ touch: UITouch) {
        guard let handler = TouchEventHandlerManager.default.handler(from: touch) else {
            return
        }

        handler.touchEnded()
        self.resetTouch(touch)
    }

    func touchCancelled(_ touch: UITouch) {
        guard let handler = TouchEventHandlerManager.default.handler(from: touch) else {
            return
        }

        handler.touchCancelled()
        self.resetTouch(touch)
    }

    func resetTouch(_ touch: UITouch) {
        TouchEventHandlerManager.default.remove(from: touch)
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
