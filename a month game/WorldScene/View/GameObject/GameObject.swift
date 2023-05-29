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
    var touchManager: WorldSceneTouchManager { return self.worldScene.touchManager }

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
    override func touchBegan(_ touch: UITouch) {
        if self.parent is Field && !self.worldScene.interactionZone.contains(self) {
            return
        }

        let didAdded = self.touchManager.add(GameObjectTouch(touch: touch, sender: self))
        self.alpha = !didAdded ? 1.0 : 0.5
    }

    override func touchMoved(_ touch: UITouch) {
        guard self.touchManager.first(from: touch) != nil else {
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

    override func touchEnded(_ touch: UITouch) {
        guard self.touchManager.first(from: touch) != nil else {
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

    override func touchCancelled(_ touch: UITouch) {
        guard self.touchManager.first(from: touch) != nil else {
            return
        }
        self.resetTouch(touch)
    }

    override func resetTouch(_ touch: UITouch) {
        self.alpha = 1.0
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

class GameObjectTouch: Touch {

}
