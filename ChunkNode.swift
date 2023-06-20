//
//  ChunkNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/20.
//

import Foundation
import SpriteKit

class ChunkNode: LMINode {

    var chunk: Chunk? = nil

    init(chunk: Chunk) {
        self.chunk = chunk
        super.init()
    }

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ChunkNode: InventoryNode {

    func isValid(_ coord: Coordinate<Int>) -> Bool {
        return true
    }

    #warning("implement")
    func addGO(_ go: GameObjectNode, to coord: Coordinate<Int>) {
    }

    func moveGO(_ go: GameObjectNode, to coord: Coordinate<Int>) {
    }

    func gameObjectAtLocation(of touch: UITouch) -> GameObjectNode? {
        return nil
    }

    func contains(_ go: GameObjectNode) -> Bool {
        return false
    }

    func makeIterator() -> some IteratorProtocol<GameObjectNode> {
        let goChildren = self.children as! [GameObjectNode]
        return goChildren.makeIterator()
    }

}
