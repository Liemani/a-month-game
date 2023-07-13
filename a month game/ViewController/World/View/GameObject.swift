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
    var type: GameObjectType { self.data.type }
    var variant: Int { self.data.variant }

    var quality: Double { self.data.quality }

    var chunkCoord: ChunkCoordinate? { self.data.chunkCoord }
    var invCoord: InventoryCoordinate? { self.data.invCoord }
    var tileCoord: Coordinate<Int>? { self.chunkCoord?.address.tile.coord }

    var isOnField: Bool { self.chunkCoord != nil }
    var isInInv: Bool { self.invCoord != nil }

    var positionInWorld: CGPoint { self.position + self.parent!.position }

    // MARK: - init
    init(from goData: GameObjectData) {
        self.data = goData

        let texture = goData.type.textures[0]

        let size = goData.type.isTile || !goData.type.isWalkable
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

        self.zPosition = !self.type.isTile
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
                     coord chunkCoord: ChunkCoordinate) {
        let goData = GameObjectData(goType: goType,
                                    variant: variant,
                                    quality: quality,
                                    state: state)
        goData.set(coord: chunkCoord)

        self.init(from: goData)
    }

    convenience init(type goType: GameObjectType,
                     variant: Int,
                     quality: Double,
                     state: GameObjectState,
                     coord invCoord: InventoryCoordinate) {
        let goData = GameObjectData(goType: goType,
                                    variant: variant,
                                    quality: quality,
                                    state: state)
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

    // MARK: -
    func set(type goType: GameObjectType) {
        self.data.set(type: goType)

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

        self.size = goType.isTile || !goType.isWalkable
            ? Constant.defaultNodeSize
            : Constant.gameObjectSize
    }

    func set(variant: Int) {
        self.data.set(variant: variant)
    }

    func set(quality: Double) {
        self.data.quality = quality
    }

    func set(coord chunkCoord: ChunkCoordinate) {
        self.data.set(coord: chunkCoord)
    }

    func set(coord invCoord: InventoryCoordinate) {
        self.data.set(coord: invCoord)
    }

    func isAccessible(by character: Character) -> Bool {
        if self.invCoord != nil {
            return true
        }

        return character.accessibleFrame.contains(self.positionInWorld)
    }

    func delete() {
        self.data.delete()
    }

}

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

extension GameObject {

    override var debugDescription: String {
        var description = "(id: \(self.id), typeID: \(self.type), variation: \(self.variant), quality: \(self.quality), state: \(self.data.state)"

        if let chunkCoord = self.chunkCoord {
            description += ", coord: \(chunkCoord))"
        }

        if let invCoord = self.invCoord {
            description += ", coord: \(invCoord))"
        }

        return description
    }

}
