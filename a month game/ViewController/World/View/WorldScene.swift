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
        self.backgroundColor = .darkGray

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

        // MARK: ui
        let ui = SKNode()
        ui.zPosition = Constant.ZPosition.ui
        self.addChild(ui)
        self.ui = ui

        let texture = SKTexture(imageNamed: Constant.ResourceName.menuButton)
        let menuButton: Button = Button(texture: texture,
                                        frame: Constant.Frame.menuButton,
                                        text: nil,
                                        eventType: WorldEventType.menuButton)
        ui.addChild(menuButton)

        ui.addChild(self.characterInv)
        ui.addChild(self.craftWindow)

        self.addChild(self.munuWindow)
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
    var pTime: TimeInterval = 0.0
    var cTime: TimeInterval = 0.0
    var timeInterval: TimeInterval { self.cTime - self.pTime }

    override func update(_ currentTime: TimeInterval) {
        if (pTime == 0.0) {
            print(currentTime)
            print(CACurrentMediaTime())
            print(CFAbsoluteTimeGetCurrent())
            print(Date.distantPast.timeIntervalSinceReferenceDate)
        }

        self.pTime = self.cTime
        self.cTime = currentTime

        self.handleEvent()

        self.updateModel()
        CharacterPositionUpdateHandler(character: self.character,
                                       movingLayer: self.movingLayer,
                                       chunkContainer: self.chunkContainer,
                                       accessibleGOTracker: self.accessibleGOTracker,
                                       timeInterval: self.timeInterval).handle()

        self.updateData()
    }

    func handleEvent() {
        while let event = WorldEventManager.default.dequeue() {
            let eventType = event.type as! WorldEventType
            eventType.handler(self, event)
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

    // MARK: - override
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        TouchManager.default.touchBegan(touch)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        TouchManager.default.touchMoved(touch)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        TouchManager.default.touchEnded(touch)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        TouchManager.default.touchCancelled(touch)
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
