//
//  GameObjectCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/15.
//

import Foundation

struct GameObjectCoordinate {

    var containerType: ContainerType
    var coordinate: Coordinate<Int>

    var x: Int { get { return self.coordinate.x } set { self.coordinate.x = newValue } }
    var y: Int { get { return self.coordinate.y } set { self.coordinate.y = newValue } }

    init(containerType: ContainerType, coordinate: Coordinate<Int>) {
        self.containerType = containerType
        self.coordinate = coordinate
    }

    init(containerType: ContainerType, x: Int, y: Int) {
        self.containerType = containerType
        self.coordinate = Coordinate<Int>(x: x, y: y)
    }

    func toCGPoint() -> CGPoint {
        return self.coordinate.toCGPoint()
    }

}
