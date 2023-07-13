//
//  CraftMasteryRepository.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/10.
//

import Foundation

class CraftMasteryRepository {

    private let craftMasteryDS: CraftMasteryDataSource

    init(craftMasteryDS: CraftMasteryDataSource) {
        self.craftMasteryDS = craftMasteryDS
    }

    func new(type goType: GameObjectType) -> CraftMasteryMO {
        let mo = self.craftMasteryDS.new()

        mo.dstTypeID = Int32(goType.rawValue)
        mo.exp = 0

        return mo
    }

}

extension CraftMasteryMO {

    func update(lv: Int) {
        self.lv = Int32(lv)
    }

    func update(exp: Int) {
        self.exp = Int32(exp)
    }

}
