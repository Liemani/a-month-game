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
    var scheduler: ChunkGOScheduler

    // MARK: - init
    override init() {
        self.data = ChunkData()
        self.scheduler = ChunkGOScheduler()

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

    func updateSchedule() {
        if self.scheduler.hasChanges {
            self.scheduler.sort()
        }
    }

}

// MARK: - inventory protocol
extension Chunk: InventoryProtocol {

    typealias Item = GameObject
    typealias Items = [GameObject]
    typealias Coord = Coordinate<UInt8>

    func isValid(_ coord: Coord) -> Bool {
        return 0 <= coord.x && coord.x < Constant.tileCountOfChunkSide
            && 0 <= coord.y && coord.y < Constant.tileCountOfChunkSide
    }

    func items(at coord: Coord) -> [GameObject]? {
        return self.data.gos(at: coord)
    }

    /// - Parameters:
    ///     - touch: suppose touch is on self
    func itemsAtLocation(of touch: UITouch) -> [GameObject]? {
        let touchedLocation = touch.location(in: self)
        let touchedCoord = CoordinateConverter(touchedLocation).coord.coordUInt8
        return self.data.gos(at: touchedCoord)
    }

    /// - Parameters:
    ///     - touch: suppose touch is on self
    func coordAtLocation(of touch: UITouch) -> Coord? {
        let touchPoint = touch.location(in: self)
        let chunkWidthHalf = Constant.chunkWidth

        guard -chunkWidthHalf <= touchPoint && touchPoint < chunkWidthHalf else {
            return nil
        }

        return CoordinateConverter(touchPoint).coord.coordUInt8
    }

    func add(_ item: GameObject, to coord: Coord) {
        self.data.add(item, to: coord)
        self.scheduler.add(item)

        let tileCoord = item.chunkCoord!.address.tile.coord
        item.position = CoordinateConverter(tileCoord).fieldPoint

        self.addChild(item)
    }

    func remove(_ item: GameObject, from coord: Coord) {
        self.data.remove(item, from: coord)
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
        let goDatas = Services.default.chunk.load(at: chunkCoord)

        var sortedGOs: [GameObject] = []

        for goData in goDatas {
            let go = GameObject(from: goData)
            let tileAddress = go.chunkCoord!.address.tile

            self.data.add(go, to: tileAddress.rawCoord)

            go.position = CoordinateConverter(tileAddress.coord).fieldPoint

            self.addChild(go)

            if go.timeEventDate != nil {
                sortedGOs.append(go)
            }
        }

        sortedGOs.sort { $0.timeEventDate! <= $1.timeEventDate! }

        self.scheduler.add(sortedGOs)

        Services.default.action.update()
    }

    func update(chunkCoord: ChunkCoordinate) {
        self.removeAll()

        // NOTE: This code generated reference freed memory address or double free
//        DispatchQueue.global(qos: .userInteractive).async {
//            let goDatas = Services.default.chunk.load(at: chunkCoord)
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

}
