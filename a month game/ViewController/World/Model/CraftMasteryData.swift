//
//  CraftMasteryData.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/09.
//

import Foundation

class CraftMasteryData {

    private var mo: CraftMasteryMO

    let dstType: GameObjectType

    var lv: Int { Int(self.mo.lv) }
    var exp: Int { Int(self.mo.exp) }

    init?(from craftMasteryMO: CraftMasteryMO) {
        guard let dstType = GameObjectType(rawValue: Int(craftMasteryMO.dstTypeID)) else {
            return nil
        }

        self.dstType = dstType

        self.mo = craftMasteryMO
    }

    init(type goType: GameObjectType) {
        self.mo = Services.default.craftMasteryRepo.new(type: goType)

        self.dstType = goType
    }

    func increase(exp: Int) {
        let newExp = self.exp + exp

        if newExp >= MasteryTable.table[self.lv].expForNextLv {
            self.mo.update(lv: self.lv + 1)
        }
        self.mo.update(exp: newExp)
    }

}
