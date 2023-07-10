//
//  MasteryLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/10.
//

import Foundation

class MasteryLogic {

    private let masteries: Masteries

    init() {
        self.masteries = Masteries()
    }

    func interact(_ dstType: GameObjectType) -> TaskResultType {
        let lv = self.masteries.interactionMasteryDatas[dstType]?.lv ?? 0

        let result = MasteryTable.result(lv: lv)

        self.masteries.updateInteraction(dstType, exp: result.rawValue)

        return result
    }

    func interact(from srcType: GameObjectType, to dstType: GameObjectType) -> TaskResultType {
        let key = GOInteractionMasteryDatasKey(from: srcType, to: dstType)
        let lv = self.masteries.goInteractionMasteryDatas[key]?.lv ?? 0

        let result = MasteryTable.result(lv: lv)

        self.masteries.updateInteraction(dstType, exp: result.rawValue)

        return result
    }

    func craft(_ dstType: GameObjectType) -> TaskResultType {
        let lv = self.masteries.craftMasteryDatas[dstType]?.lv ?? 0

        let result = MasteryTable.result(lv: lv)

        self.masteries.updateInteraction(dstType, exp: result.rawValue)

        return result
    }

}
