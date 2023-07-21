//
//  GameObjectNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation
import SpriteKit

// MARK: - class GameObjectNode
class GameObject: SKSpriteNode {

    var data: GameObjectData

    var id: Int { self.data.id }

    var type: GameObjectType {
        get { self.data.type }
        set {
            self.data.type = newValue
            self.setTexture(type: newValue)

            self._updateDateLastChanged()
        }
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
    var frameInWorld: CGRect { self.frame + self.parent!.position }
    func setTexture(type goType: GameObjectType) {
        self.texture = goType.textures[0]

        if goType.layerCount == 2 {
            if self.children.count == 1 {
                let cover = self.children[0] as! SKSpriteNode
                cover.texture = goType.textures[1]
            } else {
                let cover = SKSpriteNode(texture: goType.textures[1])
                cover.size = Constant.coverSize
                cover.zPosition = Constant.ZPosition.gameObjectCover
                self.addChild(cover)
            }
        } else {
            self.removeAllChildren()
        }

        self.size = goType.isFloor || !goType.isWalkable
            ? Constant.defaultNodeSize
            : Constant.gameObjectSize
    }

    var chunk: Chunk? { self.parent as? Chunk }
    var inventory: Inventory? { self.parent?.parent as? Inventory }

    var isDeleted: Bool { self.parent == nil }

    // MARK: - init
    init(from goData: GameObjectData) {
        self.data = goData

        let texture = goData.type.textures[0]

        let size = goData.type.isFloor || !goData.type.isWalkable
            ? Constant.defaultNodeSize
            : Constant.gameObjectSize

        super.init(texture: texture, color: .white, size: size)

        self.data.go = self

        if self.isInInv {
            self.addQualityBox()
        }

        if goData.type.layerCount == 2 {
            let cover = SKSpriteNode(texture: goData.type.textures[1])
            cover.size = Constant.coverSize
            cover.zPosition = Constant.ZPosition.gameObjectCover
            self.addChild(cover)
        }

        self.zPosition = !self.type.isFloor
                            ? Constant.ZPosition.gameObject
                            : Constant.ZPosition.tile
    }

    func addQualityBox() {
        guard self.children.first == nil else {
            return
        }

        let boxSize = Constant.Size.qualityBox

        let qualityBox = SKShapeNode(rectOf: boxSize)
        qualityBox.position = Constant.Position.qualityBox
        qualityBox.zPosition = Constant.ZPosition.gameObjectQualityLabel
        qualityBox.fillColor = .black
        qualityBox.strokeColor = .black
        qualityBox.alpha = 0.5
        self.addChild(qualityBox)

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        let qualityString = formatter.string(from: self.quality as NSNumber)!

        let qualityLabel = SKLabelNode(text: qualityString)
        qualityLabel.fontName = "Helvetica-Bold"
        qualityLabel.fontSize = 12.0
        qualityLabel.position = Constant.Position.qualityLabel
        qualityLabel.zPosition = 10.0
        qualityLabel.horizontalAlignmentMode = .right
        qualityBox.addChild(qualityLabel)
    }

    func removeQualityBox() {
        if !self.children.isEmpty {
            self.children[0].removeFromParent()
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
    func activate() {
        self.alpha = 0.5
    }

    func deactivate() {
        self.alpha = 1.0
    }

    func highlight() {
        self.color = .green.withAlphaComponent(0.9)
        self.colorBlendFactor = Constant.accessibleGOColorBlendFactor
    }

    func removeHighlight() {
        self.colorBlendFactor = 0.0
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

// MARK: - Logic
extension GameObject {

    static func new(type goType: GameObjectType,
                    variant: Int = 0,
                    quality: Double = 0.0,
                    state: GameObjectState = [],
                    coord chunkCoord: ChunkCoordinate,
                    date: Date = Date()) {
        let go = GameObject(type: goType,
                            variant: variant,
                            quality: quality,
                            state: state,
                            coord: chunkCoord,
                            date: date)
        Services.default.chunkContainer.add(go)
    }

    static func new(type goType: GameObjectType,
                    variant: Int = 0,
                    quality: Double = 0.0,
                    state: GameObjectState = [],
                    coord invCoord: InventoryCoordinate,
                    date: Date = Date()) {
        let go = GameObject(type: goType,
                            variant: variant,
                            quality: quality,
                            state: state,
                            coord: invCoord,
                            date: date)
        Logics.default.invContainer.add(go)

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func removeFromParentWithSideEffect() {
        if let chunk = self.chunk {
            chunk.remove(self, from: self.chunkCoord!.address.tile.rawCoord)
            Logics.default.accessibleGOTracker.remove(self)
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
            self.removeFromParentWithSideEffect()
            self.set(coord: invCoord)
            Logics.default.invContainer.add(self)

            return
        }

        guard invCoord.id == Constant.characterInventoryID
                || Services.default.inv.isEmpty(id: self.id) else {
            return
        }

        self.addQualityBox()

        self.removeFromParentWithSideEffect()
        self.set(coord: invCoord)
        Logics.default.invContainer.add(self)

        Logics.default.invContainer.closeAnyInv(of: self.id)
    }

    func move(to chunkCoord: ChunkCoordinate) {
        self.removeQualityBox()

        self.removeFromParentWithSideEffect()
        self.set(coord: chunkCoord)
        Services.default.chunkContainer.add(self)

        if self.type.isContainer {
            Logics.default.invContainer.closeAnyInv(of: self.id)
        }
    }

    func delete() {
        self.removeFromParentWithSideEffect()

        if self === Logics.default.touch.activatedGO {
            Logics.default.touch.freeActivatedGO()
        }

        if self.type.isContainer {
            Logics.default.invContainer.closeAnyInv(of: self.id)
        }

        self._delete()
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
        if let handler = Services.default.action.interactToGO[go.type] {
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
