//
//  InteractionMasteryData.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/09.
//

import Foundation

class GOInteractionMasteryData {

    private var mo: GOInteractionMasteryMO

    let srcType: GameObjectType
    let dstType: GameObjectType

    var lv: Int { Int(self.mo.lv) }
    var exp: Int { Int(self.mo.exp) }

    init?(from goInteractionMasteryMO: GOInteractionMasteryMO) {
        guard let srcType = GameObjectType(rawValue: Int(goInteractionMasteryMO.srcTypeID)) else {
            return nil
        }

        self.srcType = srcType

        guard let dstType = GameObjectType(rawValue: Int(goInteractionMasteryMO.dstTypeID)) else {
            return nil
        }

        self.dstType = dstType

        self.mo = goInteractionMasteryMO
    }

    init(from srcType: GameObjectType, to dstType: GameObjectType) {
        self.mo = Services.default.goInteractionMasteryRepo.new(from: srcType, to: dstType)

        self.srcType = srcType
        self.dstType = dstType
    }

    func increase(exp: Int) {
        let newExp = self.exp + exp

        if newExp >= MasteryTable.table[self.lv].expForNextLv {
            self.mo.update(lv: self.lv + 1)
            Logics.default.infoWindow.updateCharacterInfo()
        }

        self.mo.update(exp: newExp)
    }

}
