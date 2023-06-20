//
//  InventoryCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/17.
//

import Foundation

struct InventoryCoordinate {

    var id: Int
    var index: Int

    init(from invCoordMO: InventoryCoordinateMO) {
        let id = Int(invCoordMO.id)
        let index = Int(invCoordMO.index)
        self.init(id, index)
    }

    init(_ id: Int, _ index: Int) {
        self.id = id
        self.index = index
    }

}
