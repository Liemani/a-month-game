//
//  GameObjectInventory.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/06.
//

import Foundation
import SpriteKit

class GameObjectInventory: Inventory {

    func update(with go: GameObject) {
        if self.capacity != go.type.invCapacity {
            self.update(cellCount: go.type.invCapacity)
        }

        self.update(id: go.id)
    }

    func hide() {
        self.data.clear()

        self.isHidden = true
    }

    func reveal(with go: GameObject) {
        self.update(with: go)

        self.isHidden = false
    }

}
