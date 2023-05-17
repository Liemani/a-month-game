//
//  GameObject.swift
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

    static func new(id: Int?, coordinate: GameObjectCoordinate, typeID: Int) -> GameObject {
        return Resource.gameObjectTypeIDToInformation[typeID].gameObjectType.init(id: id, coordinate: coordinate)
    }

    internal init(id: Int?, coordinate: GameObjectCoordinate, typeID: Int) {
        self.id = id ?? GameObject.idGenerator.generate()
        self.coordinate = coordinate
        self.typeID = typeID
    }

    required convenience init(id: Int?, coordinate: GameObjectCoordinate) {
        self.init(id: id, coordinate: coordinate, typeID: 0)
    }

    func interact(leftHand: GameObject?, rightHand: GameObject?) {
    }

}
