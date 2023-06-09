//
//  ChunkContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/21.
//

import Foundation
import SpriteKit

class ChunkContainer: SKNode {

    private let character: Character
    var chunks: [Chunk]

    // MARK: computed property
    var lowerBound: Coordinate<Int> { self.character.chunkChunkCoord.coord + Direction9.southWest.coordOfAChunk }
    var upperBound: Coordinate<Int> { self.character.chunkChunkCoord.coord + Direction9.northEast.coordOfAChunk * 2 }

    // MARK: - init
    init(character: Character) {
        self.character = character
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

            self.setUpChunks(direction: direction)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - chunk
    func update(direction: Direction4) {
        self.shift(direction: direction.opposite)

        for direction in direction.direction9 {
            self.loadChunk(direction: direction)
        }
    }

    private func setUpChunks(direction: Direction9) {
        let chunkOffset = direction.coordOfAChunk
        let tartgetChunkCoord = self.character.chunkChunkCoord + chunkOffset
        self.chunks[direction].setUp(chunkCoord: tartgetChunkCoord)
    }

    private func loadChunk(direction: Direction9) {
        let chunkOffset = direction.coordOfAChunk
        let tartgetChunkCoord = self.character.chunkChunkCoord + chunkOffset
        self.chunks[direction].update(chunkCoord: tartgetChunkCoord)
    }

    // MARK: -
    func chunkDirection(to chunkCoord: ChunkCoordinate) -> Direction9? {
        return self.character.chunkChunkCoord.chunkDirection(to: chunkCoord)
    }

    // MARK: - private
    private func shift(direction: Direction4) {
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

    func items(at coord: ChunkCoordinate) -> [GameObject]? {
        guard let direction = self.chunkDirection(to: coord) else {
            return nil
        }

        return self.chunks[direction].items(at: coord.address.tile.coord)
    }

    func itemsAtLocation(of touch: UITouch) -> [GameObject]? {
        let touchPoint = touch.location(in: self)
        let fieldCoord = FieldCoordinate(from: touchPoint)
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

        let fieldCoord = FieldCoordinate(from: touchPoint)

        return self.character.chunkChunkCoord + fieldCoord.coord
    }

    func add(_ item: GameObject) {
        let direction = self.chunkDirection(to: item.chunkCoord!)!
        self.chunks[direction].add(item)
    }

    func remove(_ item: GameObject) {
        guard let direction = self.chunkDirection(to: item.chunkCoord!) else {
            return
        }

        self.chunks[direction].remove(item)
    }

    func makeIterator() -> some IteratorProtocol<GameObject> {
        return CombineSequences(sequences: self.chunks)
    }

}
