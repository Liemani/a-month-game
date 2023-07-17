//
//  Chunk.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/20.
//

import Foundation
import SpriteKit

class Chunk: SKNode {

    var data: ChunkData
    var scheduler: ChunkScheduler

    var hasChanges: Bool

    // MARK: - init
    override init() {
        self.data = ChunkData()
        self.scheduler = ChunkScheduler()

        self.hasChanges = false

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func removeAll() {
        self.removeAllChildren()
        self.data.removeAll()
        self.scheduler.removeAll()
    }

    func update() {
        self.scheduler.sort()

        self.hasChanges = false
    }

}

// MARK: - inventory protocol
extension Chunk: InventoryProtocol {

    func isValid(_ coord: Coordinate<Int>) -> Bool {
        return 0 <= coord.x && coord.x < Constant.tileCountOfChunkSide
            && 0 <= coord.y && coord.y < Constant.tileCountOfChunkSide
    }

    func contains(_ item: GameObject) -> Bool {
        let tileAddr = item.chunkCoord!.address.tile.value

        guard let gos = self.data.tileGOs(tileAddr: tileAddr) else {
            return false
        }

        for go in gos {
            if go.id == item.id {
                return true
            }
        }
        return false
    }

    func items(at coord: Coordinate<Int>) -> [GameObject] {
        let addr = Address(coord.x, coord.y).tile.value
        if let tileGOs = self.data.tileGOs(tileAddr: addr) {
            return tileGOs
        }

        return []
    }

    func itemsAtLocation(of touch: UITouch) -> [GameObject] {
        let touchedLocation = touch.location(in: self)
        let touchedFieldCoord = FieldCoordinate(from: touchedLocation)
        let touchedChunkCoord = ChunkCoordinate(touchedFieldCoord.coord.x, touchedFieldCoord.coord.y)

        let tileAddr = touchedChunkCoord.address.tile.value
        if let tileGOs = self.data.tileGOs(tileAddr: tileAddr) {
            return tileGOs
        }

        return []
    }

    func coordAtLocation(of touch: UITouch) -> Coordinate<Int>? {
        let touchPoint = touch.location(in: self)
        let chunkWidthHalf = Constant.chunkWidth

        guard -chunkWidthHalf <= touchPoint && touchPoint < chunkWidthHalf else {
            return nil
        }

        return FieldCoordinate(from: touchPoint).coord
    }

    func add(_ item: GameObject) {
        self.data.add(item)
        self.scheduler.add(item)

        let tileCoord = item.chunkCoord!.address.tile.coord
        item.position = FieldCoordinate(tileCoord).fieldPoint

        self.addChild(item)
    }

    func remove(_ item: GameObject) {
        self.data.remove(item)
        self.scheduler.remove(item)

        item.removeFromParent()
    }

    func makeIterator() -> some IteratorProtocol<GameObject> {
        return (self.children as! [GameObject]).makeIterator()
    }

}

// MARK: - logic
extension Chunk {

    func setUp(chunkCoord: ChunkCoordinate) {
        let goDatas = Services.default.chunkServ.load(at: chunkCoord)

        var sortedGOs: [GameObject] = []

        for goData in goDatas {
            let go = GameObject(from: goData)

            self.data.add(go)

            let tileCoord = go.chunkCoord!.address.tile.coord
            go.position = FieldCoordinate(tileCoord).fieldPoint

            self.addChild(go)

            sortedGOs.append(go)
        }

        sortedGOs.sort { $0.scheduledDate <= $1.scheduledDate }

        self.scheduler.add(sortedGOs)
    }

    func update(chunkCoord: ChunkCoordinate) {
        self.removeAll()

        // NOTE: This code generated reference freed memory address or double free
//        DispatchQueue.global(qos: .userInteractive).async {
//            let goDatas = Services.default.chunkServ.load(at: chunkCoord)
//
//            DispatchQueue.main.async {
//                for goData in goDatas {
//                    let go = GameObject(from: goData)
//
//                    chunk.add(go)
//                }
//            }
//        }

        self.setUp(chunkCoord: chunkCoord)
    }

    func add(go: GameObject) {
        self.add(go)

        Logics.default.leftGOTracker.addIfDisappearable(go)
    }

    func remove(go: GameObject) {
        self.remove(go)

        Logics.default.leftGOTracker.remove(go)
    }

}
