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

        self.updateCharacter(timeInterval)

        self.updateModel()
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


    func updateCharacter(_ timeInterval: TimeInterval) {
        self.applyCharacterVelocity(timeInterval)
        self.updateCharacterVelocity(timeInterval)
        self.resolveCharacterCollision()

        if self.hasMovedToAnotherTile {
            FrameCycleUpdateManager.default.update(with: .accessibleGOTracker)

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
        let lastTileCoord = FieldCoordinate(from: self.character.lastPosition)
        let currTileCoord = FieldCoordinate(from: self.character.position)

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
        var chunkChunkCoord = self.character.chunkChunkCoord
        chunkChunkCoord.address.tile = AddressComponent()

        let tileCoord = FieldCoordinate(from: self.character.position).coord
        let chunkCoord = chunkChunkCoord + tileCoord
        self.character.data.chunkCoord = chunkCoord
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
