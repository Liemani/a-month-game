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

    // MARK: layer
    var worldLayer: SKNode!
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

        self.characterPositionUpdateHandler = CharacterPositionUpdater(
            character: self.character,
            movingLayer: self.movingLayer,
            chunkContainer: self.chunkContainer,
            accessibleGOTracker: self.accessibleGOTracker)

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
        self.craftWindow.update(gos: self.characterInv)
        self.munuWindow = MenuWindow()
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
        let menuButton: Button = Button(texture: texture,
                                        frame: Constant.Frame.menuButton,
                                        text: nil,
                                        eventType: WorldEventType.menuButton)
        ui.addChild(menuButton)

        ui.addChild(self.characterInv)
        ui.addChild(self.craftWindow)
        ui.addChild(self.invContainer.invInv)

        self.addChild(self.munuWindow)
    }

    override func sceneDidLoad() {
        self.cTime = CACurrentMediaTime()
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

        self.handleEvent()

        self.updateModel()
        self.characterPositionUpdateHandler.update(timeInterval: self.timeInterval)

        self.updateData()
    }

    func handleEvent() {
        while let event = WorldEventManager.default.dequeue() {
            let eventType = event.type as! WorldEventType
            // TODO: remove argument self
            eventType.handler(self, event)
        }
    }

    func updateModel() {
        if FrameCycleUpdateManager.default.contains(.accessibleGOTracker) {
            self.accessibleGOTracker.update(chunkContainer: self.chunkContainer)
        }

        if FrameCycleUpdateManager.default.contains(.craftWindow) {
            self.craftWindow.update(gos: self.invContainer)
        }

        if FrameCycleUpdateManager.default.contains(.timer) {
            // TODO: implement long touch timer
        }

        FrameCycleUpdateManager.default.clear()
    }

    func updateData() {
        let moContext = ServiceContainer.default.moContext
        if moContext.hasChanges {
            try! moContext.save()
        }
    }


}

extension WorldScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            TouchRecognizerManager.default.touchBegan(touch)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            TouchRecognizerManager.default.touchMoved(touch)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            TouchRecognizerManager.default.touchEnded(touch)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            TouchRecognizerManager.default.touchCancelled(touch)
        }
    }

}

// MARK: debug
#if DEBUG
extension WorldScene {

    private func debugCode() {
        for go in self.chunkContainer {
            print("id: \(go.id), typeID: \(go.type), variation: \(go.variant), quality: \(go.quality), state: \(go.data.state), coordinate: \(go.chunkCoord!)")
        }

        for go in self.characterInv {
            print("id: \(go.id), typeID: \(go.type), variation: \(go.variant), quality: \(go.quality), state: \(go.data.state), coordinate: \(go.invCoord!)")
        }
    }

}
#endif
