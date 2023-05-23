//
//  GameObjectCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/15.
//

import Foundation

struct GameObjectCoordinate {

    var containerType: ContainerType
    var tileCoordinate: TileCoordinate

    var x: Int { get { return self.tileCoordinate.x } set { self.tileCoordinate.x = newValue } }
    var y: Int { get { return self.tileCoordinate.y } set { self.tileCoordinate.y = newValue } }

    init(containerType: ContainerType, tileCoordinate: TileCoordinate) {
        self.containerType = containerType
        self.tileCoordinate = tileCoordinate
    }

    init(containerType: ContainerType, x: Int, y: Int) {
        self.containerType = containerType
        let tileCoordinate = TileCoordinate(x: x, y: y)
        self.tileCoordinate = tileCoordinate
    }

    func toCGPoint() -> CGPoint {
        return CGPoint(x: x, y: y)
    }

}
