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
    var leftGOTracker: LeftGOTracker!

    // MARK: view
    var invContainer: InventoryContainer!
    var characterInv: CharacterInventory!

    // MARK: layer
    var worldLayer: SKNode!
    var movingLayer: MovingLayer!
    var chunkContainer: ChunkContainer!

    var character: Character!
    var ui: SKNode!
    var craftWindow: CraftWindow!

    var infoWindow: InfoWindow!

    var menuWindow: MenuWindow!
    var exitWorldButtonNode: SKNode!

    // MARK: - init
    /// initialize with size
    override init(size: CGSize) {
        super.init(size: size)

        self.scaleMode = .aspectFit
        self.backgroundColor = .darkGray

        self.initModel()
        self.initSceneLayer()

        self.characterPositionUpdateHandler = CharacterPositionUpdater(
            character: self.character,
            movingLayer: self.movingLayer,
            chunkContainer: self.chunkContainer,
            accessibleGOTracker: self.accessibleGOTracker)
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

        self.leftGOTracker = LeftGOTracker()
        FrameCycleUpdateManager.default.update(with: .leftGOTracker)

        let invContainer = InventoryContainer()
        self.invContainer = invContainer

        let characterInv = invContainer.characterInv
        self.characterInv = characterInv

        self.craftWindow = CraftWindow()
        self.craftWindow.update(gos: self.characterInv)

        self.infoWindow = InfoWindow()

        self.menuWindow = MenuWindow()
    }

    func initSceneLayer() {
        let worldLayer = SKNode()

        worldLayer.xScale = Constant.sceneScale
        worldLayer.yScale = Constant.sceneScale
        worldLayer.position = Constant.worldLayer
        worldLayer.zPosition = Constant.ZPosition.worldLayer

        self.addChild(worldLayer)
        self.worldLayer = worldLayer

        // MARK: moving layer
        worldLayer.addChild(self.character)
        worldLayer.addChild(movingLayer)
        self.invContainer.fieldInv.zPosition = Constant.ZPosition.fieldInv

        // MARK: ui
        let ui = SKNode()
        ui.zPosition = Constant.ZPosition.ui
        self.addChild(ui)
        self.ui = ui

        let texture = SKTexture(imageNamed: Constant.ResourceName.menuButton)
        let menuButton = Button(texture: texture,
                                frame: Constant.Frame.menuButton,
                                text: nil,
                                eventType: WorldEventType.menuButton)
        ui.addChild(menuButton)

        ui.addChild(self.characterInv)
        ui.addChild(self.craftWindow)
        ui.addChild(self.invContainer.invInv)
        ui.addChild(self.infoWindow)
        ui.addChild(self.menuWindow)
    }

    override func sceneDidLoad() {
        self.cTime = CACurrentMediaTime()
        self.minuteTime = CACurrentMediaTime() + 60
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
    var pTime: TimeInterval!
    var cTime: TimeInterval!
    var timeInterval: TimeInterval { self.cTime - self.pTime }
    var characterPositionUpdateHandler: CharacterPositionUpdater!

    override func update(_ currentTime: TimeInterval) {
        self.pTime = self.cTime
        self.cTime = currentTime

        // MARK: process touch
        TouchManager.default.updateTimeoutRecognizer()

        self.handleEvent(currentTime)

        self.minuteSimulate(currentTime)

        // MARK: set new character position
        self.characterPositionUpdateHandler.update(timeInterval: self.timeInterval)

        // MARK: apply new character position
        self.updateModel(currentTime)

        // MARK: save changed data
        self.updateData()
    }

    func handleEvent(_ currentTime: TimeInterval) {
        while let event = WorldEventManager.default.dequeue() {
            let eventType = event.type as! WorldEventType
            // TODO: remove argument self
            eventType.handler(self, event)
        }
    }

    var minuteTime: Double!

    func minuteSimulate(_ currentTime: TimeInterval) {
        guard currentTime >= self.minuteTime else {
            return
        }

        Logics.default.leftGOTracker.update()

        self.minuteTime += 60
    }

    func updateModel(_ currentTime: TimeInterval) {
        if FrameCycleUpdateManager.default.contains(.accessibleGOTracker) {
            self.accessibleGOTracker.update(chunkContainer: self.chunkContainer)
        }

        if FrameCycleUpdateManager.default.contains(.leftGOTracker) {
            Logics.default.leftGOTracker.update()
            self.accessibleGOTracker.update(chunkContainer: self.chunkContainer)
        }

        if FrameCycleUpdateManager.default.contains(.craftWindow) {
            self.craftWindow.update(gos: self.invContainer)
        }

        FrameCycleUpdateManager.default.clear()
    }

    func updateData() {
        let moContext = Services.default.moContext
        if moContext.hasChanges {
            try! moContext.save()
        }
    }

}

extension WorldScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            TouchManager.default.touchBegan(touch)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            TouchManager.default.touchMoved(touch)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            TouchManager.default.touchEnded(touch)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            TouchManager.default.touchCancelled(touch)
        }
    }

}

extension WorldScene: TouchResponder {

    func isRespondable(with type: TouchRecognizer.Type) -> Bool {
        switch type {
        case is TapRecognizer.Type,
            is PanRecognizer.Type,
            is PinchRecognizer.Type:
            return true
        default:
            return false
        }
    }

}
