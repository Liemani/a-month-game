//
//  FieldNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

class Field: SKSpriteNode {

    var worldScene: WorldScene { self.scene as! WorldScene }
    var interactionZone: InteractionZone { self.worldScene.interactionZone }
    var touchManager: WorldSceneTouchManager { self.worldScene.touchManager }

    func setUp() {
        self.isUserInteractionEnabled = true
        self.anchorPoint = CGPoint()
        self.size = CGSize(width: Constant.tileMapSide, height: Constant.tileMapSide)
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

    // MARK: - touch

    override func touchBegan(_ touch: UITouch) {
        guard self.touchManager.first(of: FieldTouch.self) == nil else {
            return
        }

        let fieldTouch = FieldTouch(touch: touch, sender: self)
        fieldTouch.previousTimestamp = touch.timestamp
        self.touchManager.add(fieldTouch)
    }

    override func touchMoved(_ touch: UITouch) {
        guard let fieldTouch = self.touchManager.first(of: FieldTouch.self) as! FieldTouch? else {
            return
        }

        let previousPoint = touch.previousLocation(in: self.worldScene)
        let currentPoint = touch.location(in: self.worldScene)
        let difference = currentPoint - previousPoint

        self.worldScene.movingLayer.position += difference

        fieldTouch.previousPreviousTimestamp = fieldTouch.previousTimestamp
        fieldTouch.previousTimestamp = touch.timestamp
        fieldTouch.previousPreviousLocation = previousPoint
    }

    override func touchEnded(_ touch: UITouch) {
        guard self.touchManager.first(of: FieldTouch.self) != nil else {
            return
        }

        self.worldScene.setVelocityVector()
        self.resetTouch(touch)
    }

    override func touchCancelled(_ touch: UITouch) {
        guard self.touchManager.first(of: FieldTouch.self) != nil else {
            return
        }

        self.resetTouch(touch)
    }

    override func resetTouch(_ touch: UITouch) {
        self.touchManager.removeFirst(from: touch)
    }

    // MARK: - override
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchBegan(touch) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchMoved(touch) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchEnded(touch) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchCancelled(touch) }
    }

}

// MARK: - extension
extension Field: ContainerNode {

    func isVaid(_ coord: Coordinate<Int>) -> Bool {
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

}

class FieldTouch: Touch {

    var previousPreviousTimestamp: TimeInterval!
    var previousTimestamp: TimeInterval!
    var previousPreviousLocation: CGPoint!

}
