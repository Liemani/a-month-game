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

    init() {
        self.id = 0
        self.index = 0
    }

    init(_ id: Int, _ index: Int) {
        self.id = id
        self.index = index
    }

}
