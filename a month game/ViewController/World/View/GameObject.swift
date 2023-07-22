//
//  GameObjectNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation
import SpriteKit

// MARK: - class GameObjectNode
class GameObject: SKNode {

    var data: GameObjectData

    var id: Int { self.data.id }

    var type: GameObjectType {
        get { self.data.type }
        set {
            self.data.type = newValue
            self._setTexture()

            self._updateDateLastChanged()
        }
    }

    private var _textureNode: SKSpriteNode { self.children[0] as! SKSpriteNode }
    private var _cover: SKSpriteNode? {
        return (self.children.count == 2)
            ? self._textureNode.children[1] as! SKSpriteNode?
            : nil
    }

    private func _setTexture() {
        let type = self.type
        let texture = type.texture

        self._textureNode.texture = texture
        self._textureNode.size = Constant.defaultNodeSize * type.sizeScale

        guard type.hasCover else {
            self._textureNode.position = CGPoint.zero
            self._cover?.removeFromParent()
            return
        }

        self.setCover()
    }

    func setCover() {
        if let cover = self._cover {
            cover.texture = self.type.texture
        } else {
            self._textureNode.position = Constant.Position.gameObjectCoveredBase
            self._addCover()
        }
    }

    func removeCover() {
        self._cover?.removeFromParent()
    }

    private func _addCover() {
        let cover = SKSpriteNode(texture: self.type.texture)
        cover.size = Constant.coverSize
        cover.zPosition = Constant.ZPosition.gameObjectCover
        cover.xScale = -1.0
        self.addChild(cover)
    }

    var variant: Int {
        get { self.data.variant }
        set {
            self.data.variant = newValue

            self._updateDateLastChanged()
        }
    }

    var quality: Double {
        get { self.data.quality }
        set {
            self.data.quality = newValue

            self._updateDateLastChanged()
        }
    }
    func setQuality(_ quality: Double, by result: TaskResultType) {
        self.quality = max(quality + result.qualityDiff, 0)
    }

    var chunkCoord: ChunkCoordinate? { self.data.chunkCoord }
    func set(coord chunkCoord: ChunkCoordinate) {
        self.data.set(coord: chunkCoord)

        self._updateDateLastChanged()
    }

    var invCoord: InventoryCoordinate? { self.data.invCoord }
    func set(coord invCoord: InventoryCoordinate) {
        self.data.set(coord: invCoord)

        self._updateDateLastChanged()
    }

    var tileCoord: Coordinate<Int>? { self.chunkCoord?.address.tile.coord }

    private func _updateDateLastChanged() {
        self.data.dateLastChanged = Date()

        if let chunk = self.chunk {
            chunk.scheduler.hasChanges = true
        }
    }

    var dateLastChanged: Date {
        get { self.data.dateLastChanged }
        set { self.data.dateLastChanged = newValue }
    }

    var timeEventDate: Date? { self.data.timeEventDate }

    var isOnField: Bool { self.chunkCoord != nil }
    var isInInv: Bool { self.invCoord != nil }

    var positionInWorld: CGPoint { self.position + self.parent!.position }
    var frameInWorld: CGRect {
        let accumulatedFrame = self.calculateAccumulatedFrame()
        return accumulatedFrame + self.parent!.position
    }

    var chunk: Chunk? { self.parent as? Chunk }
    var inventory: Inventory? { self.parent?.parent as? Inventory }

    var isDeleted: Bool { self.parent == nil }

    // MARK: - init
    init(from goData: GameObjectData) {
        self.data = goData

        super.init()

        self.data.go = self

        self.addChild(SKSpriteNode())

        self._setTexture()

        self.zPosition = !self.type.isFloor
                            ? Constant.ZPosition.gameObject
                            : Constant.ZPosition.tile

        if self.isOnField {
            self.setRandomFlip()
        }
    }

    convenience init(type goType: GameObjectType,
                     variant: Int,
                     quality: Double,
                     state: GameObjectState,
                     coord chunkCoord: ChunkCoordinate,
                     date: Date) {
        let goData = GameObjectData(goType: goType,
                                    variant: variant,
                                    quality: quality,
                                    state: state,
                                    date: date)
        goData.set(coord: chunkCoord)

        self.init(from: goData)
    }

    convenience init(type goType: GameObjectType,
                     variant: Int,
                     quality: Double,
                     state: GameObjectState,
                     coord invCoord: InventoryCoordinate,
                     date: Date) {
        let goData = GameObjectData(goType: goType,
                                    variant: variant,
                                    quality: quality,
                                    state: state,
                                    date: date)
        goData.set(coord: invCoord)

        self.init(from: goData)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - activate
    func removeFlip() {
        self.xScale = 1.0
    }

    func setRandomFlip() {
        self.xScale = self.type.isFloor || Bool.random() ? 1.0 : -1.0
    }

    func activate() {
        self.alpha = 0.5
    }

    func deactivate() {
        self.alpha = 1.0
    }

    func highlight() {
        self._textureNode.color = .green.withAlphaComponent(0.9)
        self._textureNode.colorBlendFactor = Constant.accessibleGOColorBlendFactor
    }

    func removeHighlight() {
        self._textureNode.colorBlendFactor = 0.0
    }

    func emphasizeUsing() {
        guard !self.hasActions() else {
            return
        }

        var action = SKAction.sequence([
            SKAction.rotate(toAngle: Double.pi / 6.0, duration: 0.2),
            SKAction.rotate(toAngle: 0, duration: 0.2),
        ])

        self.run(action)

        action = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.2),
            SKAction.scale(to: 1.0, duration: 0.2),
        ])

        self.run(action)
    }

    private func _delete() {
        self.data.delete()
    }

}

// MARK: - touch responder
extension GameObject: TouchResponder {

    func isRespondable(with type: TouchRecognizer.Type) -> Bool {
        switch type {
        case is TapRecognizer.Type:
            return true
        case is PanRecognizer.Type,
            is PinchRecognizer.Type:
            return self.isOnField
        default:
            return false
        }
    }

}

// MARK: - debug description
extension GameObject {

    override var debugDescription: String {
        var description = "(id: \(self.id), type: \(self.type), variation: \(self.variant), quality: \(self.quality), dateLastChanged: \(self.dateLastChanged)"

        if let timeEventDate = self.timeEventDate {
            description += ", timeEventDate: \(timeEventDate)"
        }

        if let chunkCoord = self.chunkCoord {
            description += ", coord: \(chunkCoord))"
        }

        if let invCoord = self.invCoord {
            description += ", coord: \(invCoord))"
        }

        return description
    }

}

// MARK: - logic
extension GameObject {

    static func new(type goType: GameObjectType,
                    variant: Int = 0,
                    quality: Double = 0.0,
                    state: GameObjectState = [],
                    coord chunkCoord: ChunkCoordinate,
                    date: Date = Date()) -> GameObject {
        let go = GameObject(type: goType,
                            variant: variant,
                            quality: quality,
                            state: state,
                            coord: chunkCoord,
                            date: date)
        Services.default.chunkContainer.add(go)

        return go
    }

    static func new(type goType: GameObjectType,
                    variant: Int = 0,
                    quality: Double = 0.0,
                    state: GameObjectState = [],
                    coord invCoord: InventoryCoordinate,
                    date: Date = Date()) -> GameObject {
        let go = GameObject(type: goType,
                            variant: variant,
                            quality: quality,
                            state: state,
                            coord: invCoord,
                            date: date)
        Logics.default.invContainer.add(go)

        FrameCycleUpdateManager.default.update(with: .craftWindow)

        return go
    }

    func removeFromParentWithSideEffect() {
        if let chunk = self.chunk {
            chunk.remove(self, from: self.chunkCoord!.address.tile.rawCoord)
            Services.default.accessibleGOTracker.tracker.remove(self)
            return
        }

        if let inventory = self.inventory {
            inventory.remove(self, from: self.invCoord!.index)
            FrameCycleUpdateManager.default.update(with: .craftWindow)
            return
        }
    }

    func move(to invCoord: InventoryCoordinate) {
        if !self.type.isContainer {
            self.removeFlip()
            self.removeFromParentWithSideEffect()
            self.set(coord: invCoord)
            Logics.default.invContainer.add(self)

            return
        }

        guard invCoord.id == Constant.characterInventoryID
                || Services.default.inv.isEmpty(id: self.id) else {
            return
        }

        self.removeFlip()
        self.removeFromParentWithSideEffect()
        self.set(coord: invCoord)
        Logics.default.invContainer.add(self)

        Logics.default.invContainer.closeAnyInv(of: self.id)
    }

    func move(to chunkCoord: ChunkCoordinate) {
        self.setRandomFlip()
        self.removeFromParentWithSideEffect()
        self.set(coord: chunkCoord)
        Services.default.chunkContainer.add(self)

        if self.type.isContainer {
            Logics.default.invContainer.closeAnyInv(of: self.id)
        }
    }

    func delete() {
        self.removeFromParentWithSideEffect()

        if self === TouchServices.default.activatedGO {
            TouchServices.default.freeActivatedGO()
        }

        if self.type.isContainer {
            Logics.default.invContainer.closeAnyInv(of: self.id)
        }

        self._delete()
    }

    func delete(result: TaskResultType) {
        guard result != .fail else { return }

        self.delete()
    }

    func interact() {
        if let handler = Services.default.action.interact[self.type] {
            if handler(self) {
                return
            }
        }

        if self.type.isContainer {
            Logics.default.scene.containerInteract(self)
        }
    }

    func interact(to go: GameObject) {
        if let handler = Services.default.action.interactGOToGO[go.type] {
            if handler(self, go) {
                return
            }
        }

        if go.type.isContainer {
            if self.type.isContainer {
                Logics.default.scene.containerTransfer(self, to: go)
            } else {
                Logics.default.scene.gameObjectInteractContainer(self, to: go)
            }

            return
        }

        if go.type.isFloor,
           let goCoord = go.chunkCoord {
            self.move(to: goCoord)

            return
        }
    }

}
