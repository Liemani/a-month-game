//
//  Chunk.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/20.
//

import Foundation
import SpriteKit

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

extension Chunk: InventoryProtocol {

    func isValid(_ coord: ChunkCoordinate) -> Bool {
        return true
    }

    func contains(_ item: GameObject) -> Bool {
        for go in self {
            let go = go as! GameObject
#warning("How to checking equality?")
            if go == item {
                return true
            }
        }
        return false
    }

    func item(at coord: ChunkCoordinate) -> GameObject? {
        for go in self {
            let go = go as! GameObject
            if go.chunkCoord!.chunk.building == coord.chunk.building {
                return go
            }
        }
        return nil
    }

    func itemAtLocation(of touch: UITouch) -> GameObject? {
        for go in self {
            let go = go as! GameObject
            if go.isBeing(touched: touch) {
                return go
            }
        }
        return nil
    }

    func add(_ item: GameObject) {
        self.addChild(item)
        let buildingCoord = item.chunkCoord!.chunk.building.coord
        item.position = TileCoordinate(buildingCoord).fieldPoint
    }

    func makeIterator() -> some IteratorProtocol {
        return self.children.makeIterator()
    }

}
