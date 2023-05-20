//
//  GameObjectCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/15.
//

import Foundation

struct GameObjectCoordinate {

    var inventory: InventoryType
    var tileCoordinate: TileCoordinate

    var x: Int { get { return self.tileCoordinate.x } set { self.tileCoordinate.x = newValue } }
    var y: Int { get { return self.tileCoordinate.y } set { self.tileCoordinate.y = newValue } }

    init(inventory: InventoryType, tileCoordinate: TileCoordinate) {
        self.inventory = inventory
        self.tileCoordinate = tileCoordinate
    }

    init(inventory: InventoryType, x: Int, y: Int) {
        self.inventory = inventory
        let tileCoordinate = TileCoordinate(x: x, y: y)
        self.tileCoordinate = tileCoordinate
    }

    func toCGPoint() -> CGPoint {
        return CGPoint(x: x, y: y)
    }

}
