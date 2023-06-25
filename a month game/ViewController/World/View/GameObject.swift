//
//  GameObjectNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation
import SpriteKit

// MARK: - usage extension
#if DEBUG
extension GameObject {

    private func set(go: GameObject,

                     midChunkCoord: ChunkCoordinate,
                     chunks: [Chunk],

                     from prevChunkCoord: ChunkCoordinate?,
                     to currChunkCoord: ChunkCoordinate) {
        if prevChunkCoord != nil {
            go.removeFromParent()
        }

        let currChunkDirection = midChunkCoord.chunkDirection(to: currChunkCoord)!
        let currChunk = chunks[currChunkDirection]
        currChunk.addChild(go)

        go.setUpPosition()
    }

}
#endif

// MARK: - class GameObjectNode
class GameObject: LMISpriteNode {

    var data: GameObjectData

    var id: Int { self.data.id }
    var type: GameObjectType { self.data.type }

    var chunkCoord: ChunkCoordinate? { self.data.chunkCoord }

    func setUpPosition() {
        self.position = TileCoordinate(self.buildingCoord!).fieldPoint
    }

    var buildingCoord: Coordinate<Int>? { self.chunkCoord?.street.building.coord }

    var invCoord: InventoryCoordinate? { self.data.invCoord }

    // MARK: - init
    init(from goData: GameObjectData) {
        self.data = goData

        let texture = goData.type.texture
        let size = Constant.defaultNodeSize
        super.init(texture: texture, color: .white, size: size)

        if goData.chunkCoord != nil {
            self.setUpPosition()
        }

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

    // MARK: - touch
    override func touchBegan(_ touch: UITouch) {
        guard TouchEventHandlerManager.default.handler(of: GameObjectTouchEventHandler.self) == nil else {
            return
        }

        guard TouchEventHandlerManager.default.handler(of: GameObjectMoveTouchEventHandler.self) == nil else {
            return
        }

        let event = TouchBeganEvent(type: .gameObject,
                                    touch: touch,
                                    sender: self)
        TouchBeganEventManager.default.enqueue(event)
    }

    override func touchMoved(_ touch: UITouch) {
        guard let handler = TouchEventHandlerManager.default.handler(from: touch) else {
            return
        }

        handler.touchMoved()
    }

    override func touchEnded(_ touch: UITouch) {
        guard let handler = TouchEventHandlerManager.default.handler(from: touch) else {
            return
        }

        handler.touchEnded()
        self.resetTouch(touch)
    }

    override func touchCancelled(_ touch: UITouch) {
        guard let handler = TouchEventHandlerManager.default.handler(from: touch) else {
            return
        }

        handler.touchEnded()
        self.resetTouch(touch)
    }

    override func resetTouch(_ touch: UITouch) {
        TouchEventHandlerManager.default.remove(from: touch)
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
