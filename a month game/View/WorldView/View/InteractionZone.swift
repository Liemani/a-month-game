//
//  InteractionZone.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/28.
//

import Foundation
import SpriteKit

class InteractionZone: LMISpriteNode {

    var field: FieldNode { self.worldScene.field }

    var gos: [GameObjectNode] = []

    private var shouldUpdate: Bool = true

    func setUp() {
        self.position = Constant.sceneCenter
        self.size = Constant.defaultNodeSize * 2.0
        self.isHidden = true
    }

    func contains(_ go: GameObjectNode) -> Bool {
        for interactableGo in gos {
            if interactableGo == go {
                return true
            }
        }
        return false
    }

    func gameObjectAtLocation(of touch: UITouch) -> GameObjectNode? {
        for go in self.gos {
            if go.isAtLocation(of: touch) {
                return go
            }
        }
        return nil
    }

    // MARK: - edit
    func add(_ gos: [GameObjectNode]) {
        self.gos += gos
        self.activate()
    }

    // MARK: - activate
    func activate(_ goNode: GameObjectNode) {
        goNode.color = .green.withAlphaComponent(0.9)
        goNode.colorBlendFactor = Constant.accessableGOColorBlendFactor
        goNode.isUserInteractionEnabled = goNode.type.isInteractable
    }

    func activate() {
        for go in self.gos {
            self.activate(go)
        }
    }

    func deactivate(_ go: GameObjectNode) {
        go.colorBlendFactor = 0.0
//        if go.parent != self.worldScene.thirdHand {
            go.isUserInteractionEnabled = false
//        }
    }

    // MARK: - update
    func reserveUpdate() { self.shouldUpdate = true }

    func update() {
        guard self.shouldUpdate else { return }

        self.reset()
        self.add(self.field.interactableGOs())

        self.worldScene.craftWindow.reserveUpdate()
        self.shouldUpdate = false
    }

    private func reset() {
        for go in self.gos {
            self.deactivate(go)
        }
        self.gos.removeAll()
    }

}
