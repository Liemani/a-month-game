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
    static func new(of goType: GameObjectType) -> GameObject {
        let go = GameObject(texture: goType.texture)
        go._type = goType
        go.size = Constant.defaultNodeSize
        go.zPosition = Constant.ZPosition.gameObject

        return go
    }

    static func new(from goMO: GameObjectMO) -> GameObject? {
        guard let goType = goMO.gameObjectType else { return nil }
        return self.new(of: goType)
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
                let coord = Coordinate<Int>(0, 0)
                self.worldScene.thirdHand.moveGOMO(from: self, to: coord)
            }
        case is InventoryCell:
            let goCoord = GameObjectCoordinate(containerType: .thirdHand, x: 0, y: 0)
            self.worldScene.moveGOMO(from: self, to: goCoord)
        case is CraftCell:
            if self.type == .none {
                self.touchCancelled(touch)
            } else {
                self.craftPane.refill(self)
            }
        default: break
        }
    }

    override func touchEnded(_ touch: UITouch) {
        guard self.touchManager.contains(from: touch) else {
            return
        }

        switch self.parent {
        case is Field:
            self.resetTouch(touch)
            self.interact()
        case is InventoryCell:
            self.resetTouch(touch)
            self.interact()
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

            let characterTC = self.worldScene.character.tileCoord
            let touchedTC = TileCoordinate(from: touch.location(in: self.worldScene.field))
            if touchedTC.isAdjacent(to: characterTC) {
                let goAtLocationOfTouch = self.worldScene.interactionZone.gameObjectAtLocation(of: touch)
                if goAtLocationOfTouch == nil {
                    let goCoord = GameObjectCoordinate(containerType: .field, coordinate: touchedTC.coord)
                    self.worldScene.moveGOMO(from: self, to: goCoord)
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

    // MARK: - interact
    func interact() {
        switch self.type {
        case .pineTree:
            guard self.parent is Field else { return }
            guard Double.random(in: 0.0...1.0) <= 0.33 else { return }
            let goMO = self.worldScene.goMOGO.field[self]!
            let spareDirections = goMO.spareDirections(goMOs: self.worldScene.goMOGO.goMOs)
            guard !spareDirections.isEmpty else { return }
            let coordToAdd = spareDirections[Int.random(in: 0..<spareDirections.count)]
            let newGOMOCoord = goMO.coord + coordToAdd
            let newGOMOGOCoord = GameObjectCoordinate(containerType: .field, coordinate: newGOMOCoord)
            self.worldScene.addGOMO(of: .branch, to: newGOMOGOCoord)
        case .woodWall:
            guard self.parent is Field else { return }
            guard Double.random(in: 0.0...1.0) <= 0.25 else { return }
            self.worldScene.removeGOMO(from: self)
        default: break
        }
    }

    // MARK: - etc
    func setPositionToLocation(of touch: UITouch) {
        self.position = touch.location(in: self.parent!)
    }

}

class GameObjectTouch: TouchModel {

}
