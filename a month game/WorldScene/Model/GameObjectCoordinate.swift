//
//  GameObjectCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/15.
//

import Foundation

struct GameObjectCoordinate {

    var inventory: InventoryType
    var x: Int
    var y: Int

    func toCGPoint() -> CGPoint {
        return CGPoint(x: x, y: y)
    }

}
