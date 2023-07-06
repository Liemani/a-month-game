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

    convenience init(type goType: GameObjectType, variant: Int) {
        let goData = GameObjectData(goType: goType, variant: variant)
        self.init(from: goData)
    }

    convenience init(type goType: GameObjectType, variant: Int, coord chunkCoord: ChunkCoordinate) {
        let goData = GameObjectData(goType: goType, variant: variant)
        goData.set(coord: chunkCoord)
        self.init(from: goData)
    }

    convenience init(type goType: GameObjectType, variant: Int, coord invCoord: InventoryCoordinate) {
        let goData = GameObjectData(goType: goType, variant: variant)
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

// MARK: - touch responder
extension GameObject: TouchResponder {

    func touchBegan(_ touch: UITouch) {
            TouchHandlerContainer.default.goHandler.began(touch: touch, go: self)
    }

    func touchMoved(_ touch: UITouch) {
        let handler = TouchHandlerContainer.default.goHandler

        guard touch == handler.touch else {
            return
        }

        handler.moved()
    }

    func touchEnded(_ touch: UITouch) {
        let handler = TouchHandlerContainer.default.goHandler

        guard touch == handler.touch else {
            return
        }

        handler.ended()
    }

    func touchCancelled(_ touch: UITouch) {
        let handler = TouchHandlerContainer.default.goHandler

        guard touch == handler.touch else {
            return
        }

        handler.cancelled()
    }

//     MARK: - interact
//    func interact() {
//        switch self.type {
//        case .pineTree:
//            guard self.parent is FieldNode else { return }
//            guard Double.random(in: 0.0...1.0) <= 0.33 else { return }
//
//            let goMO = self.worldScene.worldViewController.gameObjectsModel.goMOGO.field[self]!
//            let spareDirections = goMO.spareDirections(goMOs: self.worldScene.worldViewController.gameObjectsModel.goMOGO.goMOs)
//            guard !spareDirections.isEmpty else { return }
//            let coordToAdd = spareDirections[Int.random(in: 0..<spareDirections.count)]
//            let newGOMOCoord = goMO.coord + coordToAdd
//            let newGOMOGOCoord = GameObjectCoordinate(containerType: .field, coordinate: newGOMOCoord)
//            self.worldScene.addGOMO(of: .branch, to: newGOMOGOCoord)
//        case .woodWall:
//            guard self.parent is FieldNode else { return }
//            guard Double.random(in: 0.0...1.0) <= 0.25 else { return }
//            self.worldScene.removeGOMO(from: self)
//        default: break
//        }
//    }

}
