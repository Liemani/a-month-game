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

        go.set(chunkCoord: currChunkCoord)
    }

}
#endif

// MARK: - class GameObjectNode
class GameObject: LMISpriteNode {

    var data: GameObjectData

    var id: Int { self.data.id }
    var type: GameObjectType { self.data.type }

    var chunkCoord: ChunkCoordinate? { self.data.chunkCoord! }
    func set(chunkCoord: ChunkCoordinate) {
        let buildingLocation = chunkCoord.building
        let x = Int(buildingLocation >> 4)
        let y = Int(buildingLocation & 0x0f)
        self.position = TileCoordinate(x, y).fieldPoint
    }

    override var position: CGPoint {
        get { super.position }
        set(newPosition) {
            super.position = newPosition
        }
    }

    var buildingLocation: UInt8? { self.data.chunkCoord?.building }

    // MARK: - init
    init(from goData: GameObjectData) {
        self.data = goData

        let texture = goData.type.texture
        let size = Constant.defaultNodeSize
        super.init(texture: texture, color: .white, size: size)

        if let chunkCoord = goData.chunkCoord {
            self.set(chunkCoord: chunkCoord)
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
//    override func touchBegan(_ touch: UITouch) {
//        let result = self.touchResponderManager.add(GameObjectTouch(touch: touch, sender: self))
//
//        if result == true {
//            self.activate()
//        }
//    }

//    override func touchMoved(_ touch: UITouch) {
//        guard self.touchResponderManager.contains(from: touch) else {
//            return
//        }
//
//        if self.parent is ThirdHand {
//            self.setPositionToLocation(of: touch)
//            return
//        }
//
//        if self.isAtLocation(of: touch) {
//            return
//        }
//
////        if !self.worldScene.thirdHand.isEmpty {
////            self.touchCancelled(touch)
////            return
////        }
//
//        switch self.parent {
//        case is FieldNode:
//            if !self.isPickable {
//                self.touchCancelled(touch)
//            } else {
//                let coord = Coordinate<Int>(0, 0)
//                self.worldScene.thirdHand.moveGOMO(from: self, to: coord)
//            }
//        case is InventoryCell:
//            let goCoord = GameObjectCoordinate(containerType: .thirdHand, x: 0, y: 0)
//            self.worldScene.moveGOMO(from: self, to: goCoord)
//        case is CraftCell:
//            if self.type == .none {
//                self.touchCancelled(touch)
//            } else {
//                self.craftWindow.refill(self)
//            }
//        default: break
//        }
//    }
//
//    override func touchEnded(_ touch: UITouch) {
//        guard self.touchResponderManager.contains(from: touch) else {
//            return
//        }
//
//        switch self.parent {
//        case is FieldNode:
//            self.resetTouch(touch)
//            self.interact()
//        case is InventoryCell:
//            self.resetTouch(touch)
//            self.interact()
//        case is ThirdHand:
//            if let touchedCell = self.worldScene.inventory.cellAtLocation(of: touch) {
//                if touchedCell.isEmpty {
//                    touchedCell.moveGOMO(self)
//                    self.resetTouch(touch)
//                    return
//                } else {
//                    self.touchCancelled(touch)
//                    return
//                }
//            }
//
//            let characterTC = self.worldScene.worldViewController.character.tileCoord
//            let touchedTC = Coordinate<Int>(from: touch.location(in: self.worldScene.field))
//            if touchedTC.isAdjacent(to: characterTC) {
//                let goAtLocationOfTouch = self.worldScene.interactionZone.gameObjectAtLocation(of: touch)
//                if goAtLocationOfTouch == nil {
//                    let goCoord = GameObjectCoordinate(containerType: .field, coordinate: touchedTC.coord)
//                    self.worldScene.moveGOMO(from: self, to: goCoord)
//                    self.resetTouch(touch)
//                } else {
//                    self.touchCancelled(touch)
//                }
//            } else {
//                self.touchCancelled(touch)
//            }
//        case is CraftCell:
//            self.touchCancelled(touch)
//        default: break
//        }
//    }
//
//    override func touchCancelled(_ touch: UITouch) {
//        guard self.touchResponderManager.contains(from: touch) else {
//            return
//        }
//        self.resetTouch(touch)
//        if self.parent == self.worldScene.thirdHand {
//            self.activate()
//        }
//    }
//
//    override func resetTouch(_ touch: UITouch) {
//        self.deactivate()
//        self.touchResponderManager.removeFirst(from: touch)
//    }

    // MARK: - interact
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

    // MARK: - etc
    func setPositionToLocation(of touch: UITouch) {
        self.position = touch.location(in: self.parent!)
    }

}
