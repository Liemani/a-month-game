//
//  InteractionZone.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/28.
//

import Foundation
import SpriteKit

class InteractionZone: SKSpriteNode {

    var worldScene: WorldScene { self.scene as! WorldScene }
    var field: Field { self.worldScene.field }

    var gos: [GameObject] = []

    func setUp() {
        self.position = Constant.sceneCenter
        self.size = Constant.defaultNodeSize * 2.0
        self.isHidden = true
    }

    func contains(_ go: GameObject) -> Bool {
        for interactableGo in gos {
            if interactableGo == go {
                return true
            }
        }
        return false
    }

    func gameObjectAtLocation(of touch: UITouch) -> GameObject? {
        for go in self.gos {
            if go.isAtLocation(of: touch) {
                return go
            }
        }
        return nil
    }

    // MARK: - edit
    func add(_ go: GameObject) {
        self.gos.append(go)
        self.setGOBlendFactor(go)
    }

    func add(_ gos: [GameObject]) {
        self.gos += gos
        self.setGOsBlendFactor()
        self.applyUpdate()
    }

    func remove(_ go: GameObject) {
        if let index = self.gos.firstIndex(of: go) {
            self.gos.remove(at: index)
            go.colorBlendFactor = 0.0
        }
    }

    func setGOBlendFactor(_ go: GameObject) {
        go.color = .green.withAlphaComponent(0.9)
        go.colorBlendFactor = Constant.accessableGOColorBlendFactor
    }

    func setGOsBlendFactor() {
        for go in self.gos {
            go.color = .green.withAlphaComponent(0.9)
            go.colorBlendFactor = Constant.accessableGOColorBlendFactor
        }
    }

    // MARK: - update
    func update() {
        let newInteractableGOs = self.field.interactableGOs()

        if newInteractableGOs.count == 0 && self.gos.isEmpty {
            return
        }

        self.reset()

        self.add(newInteractableGOs)
    }

    func reset() {
        for go in self.gos {
            go.colorBlendFactor = 0.0
        }
        self.gos.removeAll()
    }

    func applyUpdate() {
        self.worldScene.craftPane.update()
    }

}
