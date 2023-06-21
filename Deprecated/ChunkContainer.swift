//
//  ChunkModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/18.
//

//import Foundation
//
//class ChunkContainer {
//
//    private let chunkRepository: ChunkRepository
//    private let goRepository: GameObjectRepository
//
//    var midChunkCoord: ChunkCoordinate
//    var chunks: [Chunk]
//
//    init(worldServiceContainer: WorldServiceContainer) {
//        self.chunkRepository = worldServiceContainer.chunkRepository
//        self.goRepository = worldServiceContainer.goRepository
//        self.midChunkCoord = ChunkCoordinate()
//        self.chunks = []
//        self.chunks.reserveCapacity(9)
//        for _ in 0..<9 {
//            let chunk = Chunk(worldServiceContainer: worldServiceContainer)
//            self.chunks.append(chunk)
//        }
//    }
//
//    var fieldGOs: some IteratorProtocol<GameObject> {
//        let sequences = self.chunks.map { $0.gos }
//        return CombineSequences(sequences: sequences)
//    }
//
//    // MARK: - chunk
//    func setUp(chunkCoord: ChunkCoordinate) {
//        for direction in Direction9.allCases {
//            let targetChunkCoord = chunkCoord + direction.coord << 4
//            self.chunks[direction].update(chunkCoord: chunkCoord)
//        }
//        self.midChunkCoord = chunkCoord
//    }
//
//    func update(chunkCoord: ChunkCoordinate, direction: Direction4) {
//        self.shift(direction: direction.opposite)
//
//        for direction in direction.direction8 {
//            let tartgetChunkCoord = chunkCoord + direction.coord << 4
//            self.chunks[direction].update(chunkCoord: chunkCoord)
//        }
//        self.midChunkCoord = chunkCoord
//    }
//
//    // MARK: - game object
//    func update(_ go: GameObject, from prevChunkCoord: ChunkCoordinate?, to currChunkCoord: ChunkCoordinate) {
//        if let prevChunkCoord = prevChunkCoord {
//            self.remove(go, from: prevChunkCoord)
//        }
//
//        let currChunkDirection = self.midChunkCoord.chunkDirection(to: currChunkCoord)!
//        let currChunk = self.chunks[currChunkDirection]
//        currChunk[go.id] = go
//
//        go.set(chunk: currChunk, chunkCoord: currChunkCoord)
//    }
//
//    func remove(_ go: GameObject, from chunkCoord: ChunkCoordinate) {
//        let chunkDirection = self.midChunkCoord.chunkDirection(to: chunkCoord)!
//        self.chunks[chunkDirection][go.id] = nil
//    }
//
//    private func shift(direction: Direction4) {
//        switch direction {
//        case .east:
//            let temp1 = self.chunks[2]
//            let temp2 = self.chunks[5]
//            let temp3 = self.chunks[8]
//            self.chunks[2] = self.chunks[1]
//            self.chunks[5] = self.chunks[4]
//            self.chunks[8] = self.chunks[7]
//            self.chunks[1] = self.chunks[0]
//            self.chunks[4] = self.chunks[3]
//            self.chunks[7] = self.chunks[6]
//            self.chunks[0] = temp1
//            self.chunks[3] = temp2
//            self.chunks[6] = temp3
//        case .south:
//            let temp1 = self.chunks[0]
//            let temp2 = self.chunks[1]
//            let temp3 = self.chunks[2]
//            self.chunks[0] = self.chunks[3]
//            self.chunks[1] = self.chunks[4]
//            self.chunks[2] = self.chunks[5]
//            self.chunks[3] = self.chunks[6]
//            self.chunks[4] = self.chunks[7]
//            self.chunks[5] = self.chunks[8]
//            self.chunks[6] = temp1
//            self.chunks[7] = temp2
//            self.chunks[8] = temp3
//        case .west:
//            let temp1 = self.chunks[0]
//            let temp2 = self.chunks[3]
//            let temp3 = self.chunks[6]
//            self.chunks[0] = self.chunks[1]
//            self.chunks[3] = self.chunks[4]
//            self.chunks[6] = self.chunks[7]
//            self.chunks[1] = self.chunks[2]
//            self.chunks[4] = self.chunks[5]
//            self.chunks[7] = self.chunks[8]
//            self.chunks[2] = temp1
//            self.chunks[5] = temp2
//            self.chunks[8] = temp3
//        case .north:
//            let temp1 = self.chunks[6]
//            let temp2 = self.chunks[7]
//            let temp3 = self.chunks[8]
//            self.chunks[6] = self.chunks[3]
//            self.chunks[7] = self.chunks[4]
//            self.chunks[8] = self.chunks[5]
//            self.chunks[3] = self.chunks[0]
//            self.chunks[4] = self.chunks[1]
//            self.chunks[5] = self.chunks[2]
//            self.chunks[0] = temp1
//            self.chunks[1] = temp2
//            self.chunks[2] = temp3
//        }
//    }
//
//}
