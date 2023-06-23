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

    var gos: [GameObject] { self.children as! [GameObject] }

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
