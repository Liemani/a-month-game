//
//  ChunkContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/21.
//

import Foundation
import SpriteKit

class ChunkContainer: SKNode {

    var chunks: SKNodeMatrix33<Chunk>

    // MARK: - init
    override init() {
        self.chunks = SKNodeMatrix33()

        super.init()

        self.zPosition = Constant.ZPosition.chunkContainer

        self.initChunks()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initChunks() {
        for (index, chunk) in self.chunks.enumerated() {
            let coordOfAChunk = Direction9(rawValue: index)!.coordOfAChunk

            chunk.position = coordOfAChunk.cgPoint * Constant.tileWidth

            self.addChild(chunk)
        }
    }

    func updateSchedule() {
        for chunk in self.chunks {
            chunk.updateSchedule()
        }
    }

    func removeAll() {
        for chunk in self.chunks {
            chunk.removeAll()
        }
    }

}

// MARK: - inventory protocol
extension ChunkContainer: InventoryProtocol {

    typealias Coord = Coordinate<Int>
    typealias Item = GameObject
    typealias Items = [Item]

    /// - Parameters:
    ///     - coord: must valid coordinate
    func chunk(containing coord: Coord) -> Chunk {
        return self.chunks.element(coord >> 4)
    }

    func isValid(_ coord: Coord) -> Bool {
        let range = 0 ..< Constant.tileCountOfChunkSide * 3

        return range.contains(coord.x) && range.contains(coord.y)
    }

    func items(at coord: Coord) -> Items? {
        guard self.isValid(coord) else {
            return []
        }

        let coordOfChunk = coord >> 4
        let chunk = self.chunks.element(coordOfChunk)
        let tileCoord = coord % Constant.tileCountOfChunkSide

        return chunk.items(at: tileCoord.coordUInt8)
    }

    func itemsAtLocation(of touch: UITouch) -> [GameObject]? {
        let touchPoint = touch.location(in: self)
        let touchedCoord = CoordinateConverter(touchPoint).coord + Constant.tileCountOfChunkSide
        let chunk = self.chunk(containing: touchedCoord)

        let touchedChunkCoord = touchedCoord % Constant.tileCountOfChunkSide

        return chunk.items(at: touchedChunkCoord.coordUInt8)
    }

    func coordAtLocation(of touch: UITouch) -> Coord? {
        let touchPoint = touch.location(in: self)

        let chunkcontainerWidthHalf = Constant.chunkWidth * 3.0 / 2.0

        guard -chunkcontainerWidthHalf <= touchPoint
            && touchPoint < chunkcontainerWidthHalf else {
            return nil
        }

        return CoordinateConverter(touchPoint).coord + Constant.tileCountOfChunkSide
    }

    /// - Parameters:
    ///     - coord: suppose is valid
    func add(_ item: GameObject, to coord: Coord) {
        let chunk = self.chunk(containing: coord)
        let coord = item.chunkCoord!.address.tile.rawCoord

        chunk.add(item, to: coord)
    }

    /// - Parameters:
    ///     - coord: suppose is valid
    func remove(_ item: GameObject, from coord: Coord) {
        let chunk = self.chunk(containing: coord)
        let coord = item.chunkCoord!.address.tile.rawCoord

        chunk.remove(item, from: coord)
    }

    func makeIterator() -> some IteratorProtocol<GameObject> {
        return CombineSequences(sequences: self.chunks.content)
    }

}
