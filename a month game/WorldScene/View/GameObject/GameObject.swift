//
//  GameObject.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation
import SpriteKit

// MARK: - class GameObject
class GameObject: SKSpriteNode {

    var worldScene: WorldScene { return self.scene as! WorldScene }

    var typeID: Int {
        let objectIdentifier = ObjectIdentifier(Swift.type(of: self))
        return GameObjectType.resource[objectIdentifier]!.typeID
    }

    var type: GameObjectType {
        return GameObjectType(rawValue: self.typeID)!
    }

    // MARK: property to be overriden
    var isWalkable: Bool { return true }
    var isPickable: Bool { return true }

    // MARK: set up
    func setUp() {
        self.isUserInteractionEnabled = true
        self.zPosition = Constant.ZPosition.gameObject
    }

    // MARK: - etc
    func moveToLocation(of touch: UITouch) {
        self.position = touch.location(in: self.parent!)
    }

    // MARK: - touch
    func touchBegan(_ touch: UITouch) {
        if self.parent is Field && !self.worldScene.interactionZone.contains(self) {
            return
        }

        let didAdded = self.worldScene.add(GameObjectTouch(touch: touch, go: self))

        guard didAdded else {
            return
        }

        self.alpha = 0.5
    }

    func touchMoved(_ touch: UITouch) {
        guard self.worldScene.containsTouch(from: touch) else {
            return
        }

        if self.parent is ThirdHand {
            self.moveToLocation(of: touch)
            return
        }

        if !self.isAtLocation(of: touch) {
            if self.parent is Field && !self.isPickable {
                self.touchCancelled(touch)
                return
            }

            guard self.worldScene.thirdHand.isEmpty else {
                self.touchCancelled(touch)
                return
            }

            let goCoord = GameObjectCoordinate(containerType: .thirdHand, x: 0, y: 0)
            self.worldScene.interactionZone.remove(self)
            self.worldScene.moveGOMO(from: self, to: goCoord)
            return
        }
    }

    func touchEnded(_ touch: UITouch) {
        guard self.worldScene.containsTouch(from: touch) else {
            return
        }

        if self.parent is Field || self.parent is InventoryCell {
            self.worldScene.interact(self)
            self.resetTouch(touch)
            return
        }

        if let touchedCell = self.worldScene.inventory.cellAtLocation(of: touch) {
            guard touchedCell.isEmpty else {
                self.resetTouch(touch)
                return
            }

            touchedCell.moveGOMO(self)
            self.resetTouch(touch)
            return
        }

        let characterTC = TileCoordinate(from: self.worldScene.characterPosition)
        let touchedTC = TileCoordinate(from: touch.location(in: self.worldScene.field))
        guard touchedTC.isAdjacent(to: characterTC) else {
            self.resetTouch(touch)
            return
        }

        let goAtLocationOfTouch = self.worldScene.interactionZone.gameObjectAtLocation(of: touch)
        guard goAtLocationOfTouch == nil else {
            self.resetTouch(touch)
            return
        }

        self.worldScene.field.moveGOMO(from: self, to: touchedTC.coord)
        self.worldScene.interactionZone.add(self)
        self.worldScene.interactionZone.applyUpdate()

        self.resetTouch(touch)
        return
    }

    func touchCancelled(_ touch: UITouch) {
        self.resetTouch(touch)
    }

    func resetTouch(_ touch: UITouch) {
        self.alpha = 1.0
        self.worldScene.removeTouch(from: touch)
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

// TODO: move
class Touch {

    let touch: UITouch

    init(_ touch: UITouch) {
        self.touch = touch
    }

}

extension Touch: Equatable {

    static func == (lhs: Touch, rhs: Touch) -> Bool {
        return lhs.touch == rhs.touch
    }

    public static func != (lhs: Touch, rhs: Touch) -> Bool {
        return !(lhs == rhs)
    }

}

// TODO: move
class GameObjectTouch: Touch {

    let touchedGO: GameObject

    init(touch: UITouch, go touchedGO: GameObject) {
        self.touchedGO = touchedGO

        super.init(touch)
    }

}
