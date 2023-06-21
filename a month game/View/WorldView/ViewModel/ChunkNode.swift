//
//  ChunkNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/20.
//

import Foundation
import SpriteKit

// MARK: usage extension
#if DEBUG
extension ChunkNode {

    /// empty chunk node
    private static func new() -> ChunkNode {
        let chunkNode = ChunkNode()
        return chunkNode
    }

    /// chunk node load and add game object node
    private static func update(chunkNode: ChunkNode, chunkCoord: ChunkCoordinate) {
        chunkNode.update(chunkCoord: chunkCoord)
    }

}
#endif

class ChunkNode: LMINode {

    var goNodes: [GameObjectNode] { self.children as! [GameObjectNode] }

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

        let gos = WorldServiceContainer.default.chunkServ.load(at: chunkCoord)
        for go in gos {
            let goNode = GameObjectNode(from: go)
            self.addChild(goNode)
        }
    }

}
