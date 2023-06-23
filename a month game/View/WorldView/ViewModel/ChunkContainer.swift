//
//  ChunkContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/21.
//

import Foundation

class ChunkContainer: LMINode {

    // MARK: - stored property
    var midChunkCoord: ChunkCoordinate
    private var chunks: [Chunk]

    // MARK: - computed property
    var gos: some Sequence<GameObject> {
        let sequences = self.chunks.map { $0.gos }
        return CombineSequences(sequences: sequences)
    }

    // MARK: - init
    override init() {
        self.midChunkCoord = ChunkCoordinate()
        self.chunks = []

        super.init()

        self.chunks.reserveCapacity(9)
        for _ in 0..<9 {
            let chunk = Chunk()
            self.chunks.append(chunk)
            self.addChild(chunk)
        }

        self.zPosition = Constant.ZPosition.chunkContainer
        self.setChunksPosition()
    }

    func setChunksPosition() {
        for direction in Direction9.allCases {
            let directionCoord = direction.coord
            let chunkPosition = (directionCoord << 4).toPoint() * Constant.tileWidth

            let chunk = self.chunks[direction]
            chunk.position = chunkPosition
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - chunk
    func setUp(chunkCoord: ChunkCoordinate) {
        for direction in Direction9.allCases {
            let targetChunkCoord = chunkCoord + direction.coord << 4
            self.chunks[direction].update(chunkCoord: targetChunkCoord)
        }
        self.midChunkCoord = chunkCoord
    }

    func update(direction: Direction4) {
        self.shift(direction: direction.opposite)

        let newMidChunkCoord = self.midChunkCoord + direction.coord << 4
        for direction in direction.direction8 {
            let tartgetChunkCoord = newMidChunkCoord + direction.coord << 4
            self.chunks[direction].update(chunkCoord: tartgetChunkCoord)
        }
        self.midChunkCoord = newMidChunkCoord
    }

    // MARK: - game object
    func update(_ go: GameObject, from prevChunkCoord: ChunkCoordinate?, to currChunkCoord: ChunkCoordinate) {
        if prevChunkCoord != nil {
            go.removeFromParent()
        }

        let currChunkDirection = self.midChunkCoord.chunkDirection(to: currChunkCoord)!
        let currChunk = self.chunks[currChunkDirection]
        currChunk.addChild(go)

        go.set(chunkCoord: currChunkCoord)
    }

    func remove(_ go: GameObject) {
        go.removeFromParent()
    }

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
        }
    }

}
