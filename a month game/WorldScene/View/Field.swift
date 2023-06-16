//
//  FieldNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

class Field: LMISpriteNode {

    func setUp() {
        self.size = CGSize(width: Constant.tileMapSide, height: Constant.tileMapSide)
        self.position = (Constant.defaultNodeSize * 256.0).toCGPoint()
        self.zPosition = Constant.ZPosition.gameObjectLayer
    }

    /// - Returns: child GOs that intersects with node
    func interactableGOs() -> [GameObject] {
        var interactableGOs = [GameObject]()

        for child in self.children {
            let child = child as! GameObject
            if child.intersects(interactionZone) {
                interactableGOs.append(child)
            }
        }
        return interactableGOs
    }

}

// MARK: - extension
extension Field: Container {

    func isValid(_ coord: Coordinate<Int>) -> Bool {
        return 0 <= coord.x && coord.x < Constant.gridSize
        && 0 <= coord.y && coord.y < Constant.gridSize
    }

    func addGO(_ go: GameObject, to coord: Coordinate<Int>) {
        self.addChild(go)
        go.position = TileCoordinate(coord).fieldPoint
    }

    func moveGO(_ go: GameObject, to coord: Coordinate<Int>) {
        go.move(toParent: self)
        go.position = TileCoordinate(coord).fieldPoint
    }

    func moveGOMO(from go: GameObject, to coord: Coordinate<Int>) {
        let goCoord = GameObjectCoordinate(containerType: .field, coordinate: coord)
        self.worldScene.moveGOMO(from: go, to: goCoord)
    }

    func gameObjectAtLocation(of touch: UITouch) -> GameObject? {
        return self.child(at: touch) as! GameObject?
    }

    func contains(_ go: GameObject) -> Bool {
        for child in self.children {
            if child == go {
                return true
            }
        }
        return false
    }

    func makeIterator() -> some IteratorProtocol<GameObject> {
        let goChildren = self.children as! [GameObject]
        return goChildren.makeIterator()
    }

}
