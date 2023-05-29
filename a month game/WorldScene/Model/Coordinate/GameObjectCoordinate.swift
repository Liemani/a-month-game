//
//  GameObjectCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/15.
//

import Foundation

struct GameObjectCoordinate {

    let containerType: ContainerType
    let coord: Coordinate<Int>

    var x: Int { get { return self.coord.x } }
    var y: Int { get { return self.coord.y } }

    init(containerType: ContainerType, coordinate: Coordinate<Int>) {
        self.containerType = containerType
        self.coord = coordinate
    }

    init(containerType: ContainerType, x: Int, y: Int) {
        self.containerType = containerType
        self.coord = Coordinate(x, y)
    }

    func toCGPoint() -> CGPoint {
        return self.coord.toCGPoint()
    }

}
