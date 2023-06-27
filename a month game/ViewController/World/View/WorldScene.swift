//
//  WorldScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import SpriteKit
import GameplayKit

class WorldScene: SKScene {

    var worldViewController: WorldViewController {
        return self.view!.next! as! WorldViewController
    }

    // MARK: model
    var accessibleGOTracker: AccessibleGOTracker!

    // MARK: view
    var invContainer: InventoryContainer!
    var characterInv: CharacterInventory!
    var leftHandGO: GameObject? { self.characterInv.leftHandGO }
    var rightHandGO: GameObject? { self.characterInv.rightHandGO }

    // MARK: layer
    var movingLayer: MovingLayer!
    var chunkContainer: ChunkContainer!

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

        self.initModel()
        self.initSceneLayer()

#if DEBUG
        self.debugCode()
#endif
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initModel() {
        self.character = Character()

        let movingLayer = MovingLayer(character: character)
        self.movingLayer = movingLayer
        self.chunkContainer = movingLayer.chunkContainer

        self.accessibleGOTracker = AccessibleGOTracker(character: character)
        FrameCycleUpdateManager.default.update(with: .accessibleGOTracker)

        let invContainer = InventoryContainer()
        self.invContainer = invContainer

        let characterInv = invContainer.characterInv
        self.characterInv = characterInv

        self.craftWindow = CraftWindow()
        self.munuWindow = MenuWindow()
    }

    func initSceneLayer() {
        let worldLayer = SKNode()
        worldLayer.xScale = Constant.sceneScale
        worldLayer.yScale = Constant.sceneScale
        worldLayer.position = Constant.worldLayer
        worldLayer.zPosition = Constant.ZPosition.worldLayer
        self.addChild(worldLayer)

        // MARK: moving layer
        worldLayer.addChild(self.character)
        worldLayer.addChild(movingLayer)

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
        ui.addChild(self.characterInv)
        ui.addChild(self.craftWindow)
        ui.addChild(self.munuWindow)
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
        self.handleEvent()

        let timeInterval = currentTime - self.lastUpdateTime

        self.updateModel()
        CharacterPositionUpdateHandler(character: self.character,
                                       movingLayer: self.movingLayer,
                                       chunkContainer: self.chunkContainer,
                                       accessibleGOTracker: self.accessibleGOTracker,
                                       timeInterval: timeInterval).handle()

        self.updateData()

        self.lastUpdateTime = currentTime
    }

    func handleEvent() {
        while let event = EventManager.default.dequeue() {
            event.type.handler(self, event)
        }
    }

    func updateModel() {
        if FrameCycleUpdateManager.default.contains(.accessibleGOTracker) {
            self.accessibleGOTracker.update(chunkContainer: self.chunkContainer)
        }

        if FrameCycleUpdateManager.default.contains(.craftWindow) {
            self.craftWindow.update()
        }

        if FrameCycleUpdateManager.default.contains(.timer) {
            // TODO: implement long touch timer
        }

        FrameCycleUpdateManager.default.clear()
    }

    func updateData() {
        let moContext = WorldServiceContainer.default.moContext
        if moContext.hasChanges {
            try! moContext.save()
        }
    }

    // MARK: - delegate

}

extension WorldScene: ButtonNodeDelegate {

    func buttonTapped(sender: Any?) {
        self.munuWindow.reveal()
    }

}

// MARK: debug
#if DEBUG
extension WorldScene {

    private func debugCode() {
        for go in self.chunkContainer {
            let go = go as! GameObject

            print("id: \(go.id), typeID: \(go.type), coordinate: (\(go.chunkCoord!))")
        }

        for go in self.characterInv {
            print("id: \(go.id), typeID: \(go.type), coordinate: (\(go.invCoord!))")
        }
    }

}
#endif
