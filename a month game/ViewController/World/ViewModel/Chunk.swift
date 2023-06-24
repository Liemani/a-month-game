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
            self.add(go)
        }
    }

}

extension Chunk: Inventory {

    func isValid(_ coord: ChunkCoordinate) -> Bool {
        return true
    }

    func contains(_ item: GameObject) -> Bool {
        for go in self {
            let go = go as! GameObject
            if go == item {
                return true
            }
        }
        return false
    }

    func item(at coord: ChunkCoordinate) -> GameObject? {
        for go in self {
            let go = go as! GameObject
            if go.chunkCoord!.street.building == coord.street.building {
                return go
            }
        }
        return nil
    }

    // MARK: edit
    func add(_ item: GameObject) {
        self.addChild(item)
        self.move(item)
    }

    func move(_ item: GameObject) {
        item.position = TileCoordinate(item.chunkCoord!.street.building.coord).fieldPoint
    }

    func remove(_ item: GameObject) {
        item.removeFromParent()
    }

    func makeIterator() -> some IteratorProtocol {
        return self.children.makeIterator()
    }

}
