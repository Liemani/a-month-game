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

    var chunkCoord: ChunkCoordinate? { self.data.chunkCoord }
    var invCoord: InventoryCoordinate? { self.data.invCoord }
    var tileCoord: Coordinate<Int>? { self.chunkCoord?.address.tile.coord }

    var isOnField: Bool { self.chunkCoord != nil }
    var isInInv: Bool { self.invCoord != nil }

    var positionFromSceneOrigin: CGPoint { self.position + self.parent!.position }

    // MARK: - init
    init(from goData: GameObjectData) {
        self.data = goData

        let texture = goData.type.texture
        let size = Constant.defaultNodeSize
        super.init(texture: texture, color: .white, size: size)

        self.zPosition = !self.type.isTile
        ? Constant.ZPosition.gameObject
        : Constant.ZPosition.tile
    }

    convenience init(goType: GameObjectType) {
        let goData = GameObjectData(type: goType)
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

    // MARK: -
    func isAccessible(by character: Character) -> Bool {
        if self.invCoord != nil {
            return true
        }

        return character.accessibleFrame.contains(self.positionFromSceneOrigin)
    }

    func lmiRemoveFromParent() {
        if let inventory = self.parent as? any InventoryProtocol<GameObject> {
            inventory.remove(self)
        } else {
            super.removeFromParent()
        }
    }

    func lmiMove(toParent parent: SKNode) {
        if let inventory = self.parent as? any InventoryProtocol<GameObject> {
            inventory.move(self, toParent: parent)
        } else {
            super.move(toParent: parent)
        }
    }

}

// MARK: - touch responder
extension GameObject: TouchResponder {

    func touchBegan(_ touch: UITouch) {
            TouchHandlerContainer.default.goHandler.began(touch: touch, go: self)
    }

    func touchMoved(_ touch: UITouch) {
        let goHandler = TouchHandlerContainer.default.goHandler

        guard touch == goHandler.touch else {
            return
        }

        goHandler.moved()
    }

    func touchEnded(_ touch: UITouch) {
        let goHandler = TouchHandlerContainer.default.goHandler

        guard touch == goHandler.touch else {
            return
        }

        goHandler.ended()
    }

    func touchCancelled(_ touch: UITouch) {
        let goHandler = TouchHandlerContainer.default.goHandler

        guard touch == goHandler.touch else {
            return
        }

        goHandler.cancelled()
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
