//
//  GameObjectCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/15.
//

import Foundation

struct GameObjectCoordinate {

    var inventoryType: InventoryType
    var tileCoordinate: TileCoordinate

    var x: Int { get { return self.tileCoordinate.x } set { self.tileCoordinate.x = newValue } }
    var y: Int { get { return self.tileCoordinate.y } set { self.tileCoordinate.y = newValue } }

    init(inventoryType: InventoryType, tileCoordinate: TileCoordinate) {
        self.inventoryType = inventoryType
        self.tileCoordinate = tileCoordinate
    }

    init(inventoryType: InventoryType, x: Int, y: Int) {
        self.inventoryType = inventoryType
        let tileCoordinate = TileCoordinate(x: x, y: y)
        self.tileCoordinate = tileCoordinate
    }

    func toCGPoint() -> CGPoint {
        return CGPoint(x: x, y: y)
    }

}
