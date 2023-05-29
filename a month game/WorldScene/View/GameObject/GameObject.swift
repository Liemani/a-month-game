//
//  GameObject.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation
import SpriteKit

// MARK: - class GameObject
class GameObject: SKSpriteNode, BelongEquatableType {

    private var _type: GameObjectType!
    var type: GameObjectType { self._type }

    // MARK: property to be overriden
    var isWalkable: Bool { self.type.isWalkable }
    var isPickable: Bool { self.type.isPickable }

    // MARK: - new
    static func new(from typeID: Int32) -> GameObject? {
        guard let type = GameObjectType(rawValue: Int(typeID)) else {
            return nil
        }

        let go = GameObject(texture: type.texture)
        go._type = type
        go.zPosition = Constant.ZPosition.gameObject

        return go
    }

    static func new(from goMO: GameObjectMO) -> GameObject? {
        return self.new(from: goMO.typeID)
    }

    // MARK: - etc
    func setPositionToLocation(of touch: UITouch) {
        self.position = touch.location(in: self.parent!)
    }

    func activate() {
        self.alpha = 0.5
    }

    func deactivate() {
        self.alpha = 1.0
    }

    // MARK: - touch
    override func touchBegan(_ touch: UITouch) {
        if self.parent is Field && !self.worldScene.interactionZone.contains(self) {
            return
        }

        let result = self.touchManager.add(GameObjectTouch(touch: touch, sender: self))

        if result == true {
            self.activate()
        }
    }

    override func touchMoved(_ touch: UITouch) {
        guard self.touchManager.contains(from: touch) else {
            return
        }

        if self.parent is ThirdHand {
            self.setPositionToLocation(of: touch)
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

    // TODO: clean, when move to third hand, go must activated
    override func touchEnded(_ touch: UITouch) {
        guard self.touchManager.contains(from: touch) else {
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
        guard self.touchManager.contains(from: touch) else {
            return
        }
        self.resetTouch(touch)
    }

    override func resetTouch(_ touch: UITouch) {
        self.deactivate()
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

class GameObjectTouch: TouchModel {

}
