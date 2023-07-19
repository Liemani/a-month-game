//
//  ChunkContainerLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/07.
//

import Foundation
import SpriteKit

class ChunkContainerLogic {

    let chunkContainer: ChunkContainer

    init(chunkContainer: ChunkContainer) {
        self.chunkContainer = chunkContainer
    }

    func setUp() {
        for direction in Direction9.allCases {
            self.setUpChunk(direction: direction)
        }
    }

    func isValid(_ chunkCoord: ChunkCoordinate) -> Bool {
        return self.chunkContainer.isValid(chunkCoord)
    }

    func contains(_ point: CGPoint) -> Bool {
        return self.chunkContainer.contains(point)
    }

    private func setUpChunk(direction: Direction9) {
        let chunk = self.chunkContainer.chunks[direction]
        let targetCoord = Services.default.character.chunkCoord.direction(direction)

        chunk.setUp(chunkCoord: targetCoord)
    }

    func update(direction: Direction9) {
        if direction == .northEast || direction == .southEast {
            self.chunkContainer.shift(direction: Direction4.east.opposite)

            for direction in Direction4.east.direction9 {
                self.updateChunk(direction: direction)
            }

            if direction == .northEast {
                self.chunkContainer.shift(direction: Direction4.north.opposite)

                for direction in Direction4.north.direction9 {
                    self.updateChunk(direction: direction)
                }
            } else {
                self.chunkContainer.shift(direction: Direction4.south.opposite)

                for direction in Direction4.south.direction9 {
                    self.updateChunk(direction: direction)
                }
            }

            return
        }

        if direction == .northWest || direction == .southWest {
            self.chunkContainer.shift(direction: Direction4.west.opposite)

            for direction in Direction4.west.direction9 {
                self.updateChunk(direction: direction)
            }

            if direction == .northWest {
                self.chunkContainer.shift(direction: Direction4.north.opposite)

                for direction in Direction4.north.direction9 {
                    self.updateChunk(direction: direction)
                }
            } else {
                self.chunkContainer.shift(direction: Direction4.south.opposite)

                for direction in Direction4.south.direction9 {
                    self.updateChunk(direction: direction)
                }
            }

            return
        }

        let direction = Direction4.table(direction)!

        self.chunkContainer.shift(direction: direction.opposite)

        for direction in direction.direction9 {
            self.updateChunk(direction: direction)
        }
    }

    private func updateChunk(direction: Direction9) {
        let chunk = self.chunkContainer.chunks[direction]
        let targetCoord = Services.default.character.chunkCoord.direction(direction)

        chunk.update(chunkCoord: targetCoord)
    }

    func coordAtLocation(of touch: UITouch) -> ChunkCoordinate? {
        return self.chunkContainer.coordAtLocation(of: touch)
    }

    func item(at chunkCoord: ChunkCoordinate) -> GameObject? {
        return self.chunkContainer.items(at: chunkCoord).first
    }

    func items(at chunkCoord: ChunkCoordinate) -> [GameObject] {
        self.chunkContainer.items(at: chunkCoord)
    }

    func add(_ go: GameObject) {
        let characterCoord = Services.default.character.chunkCoord.coord

        self.chunkContainer.add(go)

        if !go.type.isWalkable
            && go.chunkCoord!.coord.isAdjacent(to: characterCoord) {
            Logics.default.accessibleGOTracker.add(go)
        }
    }

    func forEach(_ body: (ChunkContainer.Element) -> Void) {
        self.chunkContainer.forEach(body)
    }

    var gos: some Sequence<GameObject> { self.chunkContainer }

}
