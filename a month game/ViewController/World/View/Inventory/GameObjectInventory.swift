//
//  GameObjectInventory.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/06.
//

import Foundation
import SpriteKit

class GameObjectInventory: Inventory {

    override init(id: Int? = nil,
                  texture: SKTexture? = nil,
                  cells: [InventoryCell]? = nil,
                  cellWidth: Double,
                  cellSpacing: Double) {
        super.init(id: id,
                   texture: texture,
                   cells: cells,
                   cellWidth: cellWidth,
                   cellSpacing: cellSpacing)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(_ go: GameObject) {
        guard self.id != go.id else {
            return
        }

        self.update(cellCount: go.type.invSpace)
        self.update(id: go.id)
    }

}
