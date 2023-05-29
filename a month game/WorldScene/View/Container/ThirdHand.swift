//
//  ThirdHand.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

class ThirdHand: SKNode {

    var isEmpty: Bool { self.children.isEmpty }

    var gameObject: GameObject? { self.children.first as! GameObject? }

}

extension ThirdHand: ContainerNode {

    func isVaid(_ coord: Coordinate<Int>) -> Bool {
        return true
    }

    func addGO(_ go: GameObject, to coord: Coordinate<Int>) {
        self.addChild(go)
        go.position = CGPoint()
        go.isUserInteractionEnabled = true
    }

    func moveGO(_ go: GameObject, to coord: Coordinate<Int>) {
        go.move(toParent: self)
        go.isUserInteractionEnabled = true
    }

    func moveGOMO(from go: GameObject, to coord: Coordinate<Int>) {
        let worldScene = self.scene as! WorldScene
        let goCoord = GameObjectCoordinate(containerType: .thirdHand, coordinate: coord)
        worldScene.moveGOMO(from: go, to: goCoord)
    }

    func gameObjectAtLocation(of touch: UITouch) -> GameObject? {
        return self.children.first as! GameObject?
    }

    func contains(_ go: GameObject) -> Bool {
        return self.children.first == go
    }

    func makeIterator() -> some IteratorProtocol<GameObject> {
        let goChildren = self.children as! [GameObject]
        return goChildren.makeIterator()
    }

}
