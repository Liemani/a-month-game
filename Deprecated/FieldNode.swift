//
//  FieldNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

class FieldNode: LMINode {

    var chunkNodes: [ChunkNode]

    override init() {
        self.chunkNodes = [ChunkNode](repeating: ChunkNode(), count: 9)

        super.init()

        self.zPosition = Constant.ZPosition.gameObjectLayer
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// - Returns: child GOs that intersects with node
    func interactableGOs() -> [GameObjectNode] {
        var interactableGOs = [GameObjectNode]()

        for child in self.children {
            guard let child = child as? GameObjectNode else {
                continue
            }
            if child.intersects(interactionZone) {
                interactableGOs.append(child)
            }
        }
        return interactableGOs
    }

}

// MARK: - InventoryNode
extension FieldNode: GameObjectNodeContainer {

    func isValid(_ coord: Coordinate<Int>) -> Bool {
        return true
//        return 0 <= coord.x && coord.x < Constant.gridSize
//        && 0 <= coord.y && coord.y < Constant.gridSize
    }

    func addGO(_ go: GameObjectNode, to coord: Coordinate<Int>) {
        self.addChild(go)
        go.position = TileCoordinate(coord).fieldPoint
    }

    func moveGO(_ go: GameObjectNode, to coord: Coordinate<Int>) {
        go.move(toParent: self)
        go.position = TileCoordinate(coord).fieldPoint
    }

    func gameObjectAtLocation(of touch: UITouch) -> GameObjectNode? {
        return self.child(at: touch) as! GameObjectNode?
    }

    func contains(_ go: GameObjectNode) -> Bool {
        for child in self.children {
            if child == go {
                return true
            }
        }
        return false
    }

    func makeIterator() -> some IteratorProtocol<GameObjectNode> {
        let goChildren = self.children as! [GameObjectNode]
        return goChildren.makeIterator()
    }

}
