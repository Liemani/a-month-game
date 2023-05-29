//
//  GameObject.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation
import SpriteKit

// MARK: - class GameObject
class GameObject: SpriteNode, BelongEquatableType {

    var craftPane: CraftPane { self.parent?.parent as! CraftPane }

    private var _type: GameObjectType!
    var type: GameObjectType { get { self._type } set { self._type = newValue } }

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

    // MARK: - set type
    func setType(_ goType: GameObjectType) {
        self.type = goType
        self.texture = goType.texture
    }

    // MARK: - activate
    func activate() {
        self.alpha = 0.5
    }

    func deactivate() {
        self.alpha = 1.0
    }

    // MARK: - touch
    override func touchBegan(_ touch: UITouch) {
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

        if self.isAtLocation(of: touch) {
            return
        }

        if !self.worldScene.thirdHand.isEmpty {
            self.touchCancelled(touch)
            return
        }

        switch self.parent {
        case is Field:
            if !self.isPickable {
                self.touchCancelled(touch)
            } else {
                let goCoord = GameObjectCoordinate(containerType: .thirdHand, x: 0, y: 0)
                self.worldScene.interactionZone.remove(self)
                self.worldScene.moveGOMO(from: self, to: goCoord)
            }
        case is InventoryCell:
            let goCoord = GameObjectCoordinate(containerType: .thirdHand, x: 0, y: 0)
            self.worldScene.moveGOMO(from: self, to: goCoord)
        case is CraftCell:
            self.craftPane.refill(self)
        default: break
        }
    }

    override func touchEnded(_ touch: UITouch) {
        guard self.touchManager.contains(from: touch) else {
            return
        }

        switch self.parent {
        case is Field:
            self.worldScene.interact(self)
            self.resetTouch(touch)
        case is InventoryCell:
            self.worldScene.interact(self)
            self.resetTouch(touch)
        case is ThirdHand:
            if let touchedCell = self.worldScene.inventory.cellAtLocation(of: touch) {
                if touchedCell.isEmpty {
                    touchedCell.moveGOMO(self)
                    self.resetTouch(touch)
                    return
                } else {
                    self.touchCancelled(touch)
                    return
                }
            }
            let characterTC = TileCoordinate(from: self.worldScene.characterPosition)
            let touchedTC = TileCoordinate(from: touch.location(in: self.worldScene.field))
            if touchedTC.isAdjacent(to: characterTC) {
                let goAtLocationOfTouch = self.worldScene.interactionZone.gameObjectAtLocation(of: touch)
                if goAtLocationOfTouch == nil {
                    self.worldScene.field.moveGOMO(from: self, to: touchedTC.coord)
                    self.worldScene.interactionZone.add(self)
                    self.worldScene.interactionZone.applyUpdate()
                    self.resetTouch(touch)
                } else {
                    self.touchCancelled(touch)
                }
            } else {
                self.touchCancelled(touch)
            }
        case is CraftCell:
            self.touchCancelled(touch)
        default: break
        }
    }

    override func touchCancelled(_ touch: UITouch) {
        guard self.touchManager.contains(from: touch) else {
            return
        }
        self.resetTouch(touch)
        if self.parent == self.worldScene.thirdHand {
            self.activate()
        }
    }

    override func resetTouch(_ touch: UITouch) {
        self.deactivate()
        self.touchManager.removeFirst(from: touch)
    }

    // MARK: - etc
    func setPositionToLocation(of touch: UITouch) {
        self.position = touch.location(in: self.parent!)
    }

}

class GameObjectTouch: TouchModel {

}
