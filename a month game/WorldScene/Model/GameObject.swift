//
//  GameItem.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation

class GameObject {

    static private let idGenerator = IDGenerator.default

    let id: Int
    var coordinate: GameObjectCoordinate
    let typeID: Int

    init(id: Int?, coordinate: GameObjectCoordinate, typeID: Int) {
        self.id = id ?? GameObject.idGenerator.generate()
        self.typeID = typeID
        self.coordinate = coordinate
    }

    required convenience init(id: Int?, coordinate: GameObjectCoordinate) {
        self.init(id: id, coordinate: coordinate, typeID: 0)
    }

}
