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

    func isValid(_ coord: Coordinate<Int>) -> Bool {
        return 0 <= coord.x && coord.x < Constant.tileCountOfChunkSide
            && 0 <= coord.y && coord.y < Constant.tileCountOfChunkSide
    }

    func contains(_ item: GameObject) -> Bool {
        for go in self {
            let go = go as! GameObject
#warning("How to checking equality?")
            if item.id == go.id {
                return true
            }
        }
        return false
    }

    func item(at coord: Coordinate<Int>) -> GameObject? {
        for go in self {
            let go = go as! GameObject
            if coord == go.chunkCoord!.address.tile.coord {
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

    func coordAtLocation(of touch: UITouch) -> Coordinate<Int>? {
        let touchPoint = touch.location(in: self)
        let chunkWidthHalf = Constant.chunkWidth

        guard -chunkWidthHalf <= touchPoint && touchPoint < chunkWidthHalf else {
            return nil
        }

        return FieldCoordinate(from: touchPoint).coord
    }

    func add(_ item: GameObject) {
        self.addChild(item)
        let tileCoord = item.chunkCoord!.address.tile.coord
        item.position = FieldCoordinate(tileCoord).fieldPoint
    }

    func makeIterator() -> some IteratorProtocol {
        return self.children.makeIterator()
    }

}
