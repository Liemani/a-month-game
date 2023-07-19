//
//  ChunkContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/21.
//

import Foundation
import SpriteKit

class ChunkContainer: SKNode {

    var chunks: [Chunk]

    // MARK: computed property
    var lowerBound: Coordinate<Int> {
        let middleChunkChunkCoord = Services.default.character.chunkCoord.chunk.coord
        return middleChunkChunkCoord + Direction9.southWest.coordOfAChunk
    }
    var upperBound: Coordinate<Int> {
        let middleChunkChunkCoord = Services.default.character.chunkCoord.chunk.coord
        return middleChunkChunkCoord + Direction9.northEast.coordOfAChunk * 2
    }

    // MARK: - init
    override init() {
        self.chunks = []

        super.init()

        self.chunks.reserveCapacity(9)
        self.initChunks()

        self.zPosition = Constant.ZPosition.chunkContainer
    }

    func initChunks() {
        for direction in Direction9.allCases {
            let chunk = Chunk()

            chunk.position = direction.coordOfAChunk.cgPoint * Constant.tileWidth

            self.addChild(chunk)
            self.chunks.append(chunk)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update() {
        for chunk in chunks {
            chunk.update()
        }
    }

    // MARK: -
    func chunkDirection9(to targetChunkCoord: ChunkCoordinate) -> Direction9? {
        let middleChunkCoord = Services.default.character.chunkCoord
        return middleChunkCoord.chunkDirection9(to: targetChunkCoord)
    }

    // MARK: - private
    func shift(direction: Direction4) {
        switch direction {
        case .east:
            let temp1 = self.chunks[2]
            let temp2 = self.chunks[5]
            let temp3 = self.chunks[8]
            self.chunks[2] = self.chunks[1]
            self.chunks[5] = self.chunks[4]
            self.chunks[8] = self.chunks[7]
            self.chunks[1] = self.chunks[0]
            self.chunks[4] = self.chunks[3]
            self.chunks[7] = self.chunks[6]
            self.chunks[0] = temp1
            self.chunks[3] = temp2
            self.chunks[6] = temp3
            let temp4 = self.chunks[0].position
            let temp5 = self.chunks[3].position
            let temp6 = self.chunks[6].position
            self.chunks[0].position = self.chunks[1].position
            self.chunks[3].position = self.chunks[4].position
            self.chunks[6].position = self.chunks[7].position
            self.chunks[1].position = self.chunks[2].position
            self.chunks[4].position = self.chunks[5].position
            self.chunks[7].position = self.chunks[8].position
            self.chunks[2].position = temp4
            self.chunks[5].position = temp5
            self.chunks[8].position = temp6
        case .south:
            let temp1 = self.chunks[0]
            let temp2 = self.chunks[1]
            let temp3 = self.chunks[2]
            self.chunks[0] = self.chunks[3]
            self.chunks[1] = self.chunks[4]
            self.chunks[2] = self.chunks[5]
            self.chunks[3] = self.chunks[6]
            self.chunks[4] = self.chunks[7]
            self.chunks[5] = self.chunks[8]
            self.chunks[6] = temp1
            self.chunks[7] = temp2
            self.chunks[8] = temp3
            let temp4 = self.chunks[6].position
            let temp5 = self.chunks[7].position
            let temp6 = self.chunks[8].position
            self.chunks[6].position = self.chunks[3].position
            self.chunks[7].position = self.chunks[4].position
            self.chunks[8].position = self.chunks[5].position
            self.chunks[3].position = self.chunks[0].position
            self.chunks[4].position = self.chunks[1].position
            self.chunks[5].position = self.chunks[2].position
            self.chunks[0].position = temp4
            self.chunks[1].position = temp5
            self.chunks[2].position = temp6
        case .west:
            let temp1 = self.chunks[0]
            let temp2 = self.chunks[3]
            let temp3 = self.chunks[6]
            self.chunks[0] = self.chunks[1]
            self.chunks[3] = self.chunks[4]
            self.chunks[6] = self.chunks[7]
            self.chunks[1] = self.chunks[2]
            self.chunks[4] = self.chunks[5]
            self.chunks[7] = self.chunks[8]
            self.chunks[2] = temp1
            self.chunks[5] = temp2
            self.chunks[8] = temp3
            let temp4 = self.chunks[2].position
            let temp5 = self.chunks[5].position
            let temp6 = self.chunks[8].position
            self.chunks[2].position = self.chunks[1].position
            self.chunks[5].position = self.chunks[4].position
            self.chunks[8].position = self.chunks[7].position
            self.chunks[1].position = self.chunks[0].position
            self.chunks[4].position = self.chunks[3].position
            self.chunks[7].position = self.chunks[6].position
            self.chunks[0].position = temp4
            self.chunks[3].position = temp5
            self.chunks[6].position = temp6
        case .north:
            let temp1 = self.chunks[6]
            let temp2 = self.chunks[7]
            let temp3 = self.chunks[8]
            self.chunks[6] = self.chunks[3]
            self.chunks[7] = self.chunks[4]
            self.chunks[8] = self.chunks[5]
            self.chunks[3] = self.chunks[0]
            self.chunks[4] = self.chunks[1]
            self.chunks[5] = self.chunks[2]
            self.chunks[0] = temp1
            self.chunks[1] = temp2
            self.chunks[2] = temp3
            let temp4 = self.chunks[0].position
            let temp5 = self.chunks[1].position
            let temp6 = self.chunks[2].position
            self.chunks[0].position = self.chunks[3].position
            self.chunks[1].position = self.chunks[4].position
            self.chunks[2].position = self.chunks[5].position
            self.chunks[3].position = self.chunks[6].position
            self.chunks[4].position = self.chunks[7].position
            self.chunks[5].position = self.chunks[8].position
            self.chunks[6].position = temp4
            self.chunks[7].position = temp5
            self.chunks[8].position = temp6
        }
    }

}

// MARK: - inventory protocol
extension ChunkContainer: InventoryProtocol {

    func isValid(_ coord: ChunkCoordinate) -> Bool {
        let coord = coord.coord
        let lowerBound = self.lowerBound
        let upperBound = self.upperBound

        return lowerBound.x <= coord.x && coord.x < upperBound.x
            && lowerBound.y <= coord.y && coord.y < upperBound.y
    }

    /// - Suppose: item is alwasy has chunk coordinate
    func contains(_ item: GameObject) -> Bool {
        guard let goChunkCoord = item.chunkCoord else {
            return false
        }

        return self.isValid(goChunkCoord)
    }

    func items(at coord: ChunkCoordinate) -> [GameObject] {
        guard let direction = self.chunkDirection9(to: coord) else {
            return []
        }

        return self.chunks[direction].items(at: coord.address.tile.coord)
    }

    func itemsAtLocation(of touch: UITouch) -> [GameObject] {
        let touchPoint = touch.location(in: self)
        let fieldCoord = CoordinateConverter(touchPoint)
        let directionCoord = fieldCoord.coord
        let chunkDirectionCoord = directionCoord / Constant.tileCountOfChunkSide
        let chunk = self.chunks[chunkDirectionCoord.y * 3 + chunkDirectionCoord.x]
        let gos = chunk.itemsAtLocation(of: touch)

        return gos
    }

    func coordAtLocation(of touch: UITouch) -> ChunkCoordinate? {
        let touchPoint = touch.location(in: self)

        let chunkcontainerWidthHalf = Constant.chunkWidth * 3.0 / 2.0

        guard -chunkcontainerWidthHalf <= touchPoint
            && touchPoint < chunkcontainerWidthHalf else {
            return nil
        }

        let fieldCoord = CoordinateConverter(touchPoint)

        let middleChunkCoord = Services.default.character.chunkCoord.chunk
        return middleChunkCoord + fieldCoord.coord
    }

    func add(_ item: GameObject) {
        let direction = self.chunkDirection9(to: item.chunkCoord!)!
        self.chunks[direction].add(item)
    }

    func remove(_ item: GameObject) {
        guard let direction = self.chunkDirection9(to: item.chunkCoord!) else {
            return
        }

        self.chunks[direction].remove(item)
    }

    func makeIterator() -> some IteratorProtocol<GameObject> {
        return CombineSequences(sequences: self.chunks)
    }

}
