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
    var accessableGOTracker: AccessableGOTracker!
    
    // MARK: view
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

        self.initSceneLayer()
        
        self.accessableGOTracker = AccessableGOTracker()
        WorldUpdateManager.default.update(with: .interaction)

#if DEBUG
        self.debugCode()
#endif
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
        let character = Character()
        worldLayer.addChild(character)
        self.character = character

        let movingLayer = MovingLayer(character: character)
        worldLayer.addChild(movingLayer)
        self.movingLayer = movingLayer
        self.chunkContainer = movingLayer.chunkContainer

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

        let characterInv = CharacterInventory(id: 0)
        ui.addChild(characterInv)
        self.characterInv = characterInv

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
        self.handleEvent()

        let timeInterval = currentTime - self.lastUpdateTime

        self.updateCharacter(timeInterval)
        if WorldUpdateManager.default.contains(.interaction) {
            self.accessableGOTracker.updateWhole(character: self.character,
                                                 gos: self.chunkContainer)
        }

        self.updateData()

        self.lastUpdateTime = currentTime
    }

    func updateData() {
        let moContext = WorldServiceContainer.default.moContext
        if moContext.hasChanges {
            try! moContext.save()
        }
    }

    func handleEvent() {
        while let event = EventManager.default.dequeue() {
            self.eventHandlers[event.type](self, event)
        }
    }

    let eventHandlers: [(WorldScene, Event) -> Void] = [
        { scene, event in
            let handler = CharacterMoveTouchEventHandler(
                touch: event.udata as! UITouch,
                worldScene: scene,
                character: scene.character)
            if TouchEventHandlerManager.default.add(handler) {
                handler.touchBegan()
            }
        }, { scene, event in
            let handler = GameObjectTouchEventHandler(
                touch: event.udata as! UITouch,
                go: event.sender as! GameObject)
            if TouchEventHandlerManager.default.add(handler) {
                handler.touchBegan()
            }
        }, { scene, event in
            let handler = GameObjectMoveTouchEventHandler(
                touch: event.udata as! UITouch,
                go: event.sender as! GameObject)
            if TouchEventHandlerManager.default.add(handler) {
                handler.touchBegan()
            }
        }, { scene, event in
            let handler = GameObjectMoveTouchEndedEventHandler(
                touch: event.udata as! UITouch,
                go: event.sender as! GameObject,
                chunkContainer: scene.chunkContainer)
            handler.handle()
        }, { scene, event in
            scene.character.addChild(event.sender as! GameObject)
        }, { scene, event in
            let go = event.sender as! GameObject
            go.removeFromParent()
            scene.chunkContainer.add(go)
        }, { scene, event in
            scene.accessableGOTracker.add(event.sender as! GameObject)
        }, { scene, event in
            scene.accessableGOTracker.remove(event.sender as! GameObject)
        }
    ]

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

        let event = Event(type: .characterTouchBegan,
                          udata: touch,
                          sender: self)
        EventManager.default.enqueue(event)
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


    func updateCharacter(_ timeInterval: TimeInterval) {
        self.applyCharacterVelocity(timeInterval)
        self.updateCharacterVelocity(timeInterval)
        self.resolveCharacterCollision()

        if self.hasMovedToAnotherTile {
            WorldUpdateManager.default.update(with: .interaction)

            if let direction = self.currChunkDirection {
                self.character.moveChunk(direction: direction)
                chunkContainer.update(direction: direction)
            }
        }

        self.movingLayer.position = -self.character.position
        self.character.lastPosition = self.character.position

        self.saveCharacterPosition()
    }

    private func applyCharacterVelocity(_ timeInterval: TimeInterval) {
        let differenceVector = self.character.velocityVector * timeInterval
        self.character.position += differenceVector
    }

    // TODO: update wrong formula
    private func updateCharacterVelocity(_ timeInterval: TimeInterval) {
        let velocity = self.character.velocityVector.magnitude
        self.character.velocityVector =
            velocity > Constant.velocityDamping
                ? self.character.velocityVector * pow(Constant.velocityFrictionRatioPerSec, timeInterval)
                : CGVector()
    }

    private func resolveCharacterCollision() {
        //        self.character.resolveWorldBorderCollision()
        //        self.character.resolveCollisionOfNonWalkable()
    }

//    private func resolveWorldBorderCollision() {
//        self.character.position.x = self.character.position.x < Constant.moveableArea.minX
//        ? Constant.moveableArea.minX
//        : self.character.position.x
//        self.character.position.x = self.character.position.x > Constant.moveableArea.maxX
//        ? Constant.moveableArea.maxX
//        : self.character.position.x
//        self.character.position.y = self.character.position.y < Constant.moveableArea.minY
//        ? Constant.moveableArea.minY
//        : self.character.position.y
//        self.character.position.y = self.character.position.y > Constant.moveableArea.maxY
//        ? Constant.moveableArea.maxY
//        : self.character.position.y
//    }

    var hasMovedToAnotherTile: Bool {
        let lastTileCoord = TileCoordinate(from: self.character.lastPosition)
        let currTileCoord = TileCoordinate(from: self.character.position)

        return lastTileCoord != currTileCoord
    }

    var currChunkDirection: Direction4? {
        let halfChunkwidth = Constant.chunkWidth / 2.0
        if self.character.position.x > halfChunkwidth {
            return .east
        } else if self.character.position.y < -halfChunkwidth {
            return .south
        } else if self.character.position.x < -halfChunkwidth {
            return .west
        } else if self.character.position.y > halfChunkwidth {
            return .north
        }
        return nil
    }

    func saveCharacterPosition() {
        var streetChunkCoord = self.character.streetChunkCoord
        streetChunkCoord.street.building = AddressComponent()

        let buildingCoord = TileCoordinate(from: self.character.position).coord
        let chunkCoord = streetChunkCoord + buildingCoord
        self.character.data.chunkCoord = chunkCoord
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
