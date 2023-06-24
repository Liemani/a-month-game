//
//  Chunk.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/20.
//

import Foundation

// MARK: usage extension
#if DEBUG
extension Chunk {

    /// empty chunk node
    private static func new() -> Chunk {
        let chunk = Chunk()
        return chunk
    }

    /// chunk node load and add game object node
    private static func update(chunk: Chunk, chunkCoord: ChunkCoordinate) {
        chunk.update(chunkCoord: chunkCoord)
    }

}
#endif

class Chunk: LMINode {

    // MARK: - init
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - edit
    // MARK: chunk
    func update(chunkCoord: ChunkCoordinate) {
        self.removeAllChildren()

        let goDatas = WorldServiceContainer.default.chunkServ.load(at: chunkCoord)
        for goData in goDatas {
            let go = GameObject(from: goData)
            self.addChild(go)
        }
    }

}

extension Chunk: Inventory<GameObject, Coordinate<Int>> {

    func contains(_ go: GameObject) -> Bool {
        for childGO in self.child {
            if childGO == go {
                return true
            }
        }
        return false
    }

    func isValid(_ coord: Coordinate<Int>) -> Bool {
        let tileCountOfChunkSide = Constant.tileCountOfChunkSide
        return 0 <= coord.x && coord.x < tileCountOfChunkSide
            && 0 <= coord.y && coord.y < tileCountOfChunkSide
    }

    func element(at coord: Coordinate<Int>) -> GameObject? {
        for go in self {
            go.coord == coord
        }
    }

    func coord(of go: GameObject) -> Coordinate<Int>? {
    }

    // MARK: edit
    func add(_ go: GameObject, to coord: Coordinate<Int>) {
    }

    func move(_ go: GameObject,
            from coord: Coordinate<Int>,
            to coord: Coordinate<Int>) {
    }

    func remove(_ go: GameObject, from coord: Coordinate<Int>) {
    }

    func makeIterator() -> [GameObject] {
        return self.children as! [GameObject]
    }

}
