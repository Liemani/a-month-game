//
//  ChunkContainerLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/07.
//

import Foundation
import SpriteKit

class ChunkContainerLogic {

    private let chunkContainer: ChunkContainer

    init(chunkContainer: ChunkContainer) {
        self.chunkContainer = chunkContainer
    }

    func setUp() {
        for direction in Direction9.allCases {
            self.setUpChunk(direction: direction)
        }
    }

    private func setUpChunk(direction: Direction9) {
        let chunk = self.chunkContainer.chunks[direction]
        let targetChunkCoord = Logics.default.character.chunkChunkCoord
            + direction.coordOfAChunk

        chunk.setUp(chunkCoord: targetChunkCoord)
    }

    func update(direction: Direction4) {
        self.chunkContainer.shift(direction: direction.opposite)

        for direction in direction.direction9 {
            self.updateChunk(direction: direction)
        }
    }

    private func updateChunk(direction: Direction9) {
        let chunk = self.chunkContainer.chunks[direction]
        let targetChunkCoord = Logics.default.character.chunkChunkCoord
            + direction.coordOfAChunk

        chunk.update(chunkCoord: targetChunkCoord)
    }

    func coordAtLocation(of touch: UITouch) -> ChunkCoordinate? {
        return self.chunkContainer.coordAtLocation(of: touch)
    }

    func item(at chunkCoord: ChunkCoordinate) -> GameObject? {
        return self.chunkContainer.items(at: chunkCoord)?.first
    }

    func items(at chunkCoord: ChunkCoordinate) -> [GameObject]? {
        self.chunkContainer.items(at: chunkCoord)
    }

    func add(_ go: GameObject) {
        let characterCoord = Logics.default.character.chunkCoord.coord

        self.chunkContainer.add(go)

        if !go.type.isWalkable
            && go.chunkCoord!.coord.isAdjacent(to: characterCoord) {
            Logics.default.accessibleGOTracker.add(go)
        }
    }

    func forEach(_ body: (ChunkContainer.Element) -> Void) {
        self.chunkContainer.forEach(body)
    }

}
