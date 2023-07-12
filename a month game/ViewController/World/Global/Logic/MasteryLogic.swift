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

        self.masteries.updateInteraction(dstType, exp: result.exp)

        Particle.flutter(result: result)

        return result
    }

    func interact(with srcType: GameObjectType, to dstType: GameObjectType) -> TaskResultType {
        let key = GOInteractionMasteryDatasKey(from: srcType, to: dstType)
        let lv = self.masteries.goInteractionMasteryDatas[key]?.lv ?? 0

        let result = MasteryTable.result(lv: lv)

        self.masteries.updateInteraction(with: srcType, to: dstType, exp: result.exp)

        Particle.flutter(result: result)

        return result
    }

    func craft(_ dstType: GameObjectType) -> TaskResultType {
        let lv = self.masteries.craftMasteryDatas[dstType]?.lv ?? 0

        let result = MasteryTable.result(lv: lv)

        self.masteries.updateCraft(dstType, exp: result.exp)

        Particle.flutter(result: result)

        return result
    }

    var description: String {
        var description = ""

        description.append("interaction:\n")

        for masteryData in self.masteries.interactionMasteryDatas.values {
            description.append("\(masteryData.dstType): \(masteryData.lv)\n")
        }

        description.append("\ngame object interaction:\n")

        for masteryData in self.masteries.goInteractionMasteryDatas.values {
            description.append("\(masteryData.srcType) -> \(masteryData.dstType): \(masteryData.lv)\n")
        }

        description.append("\ncraft:\n")

        for masteryData in self.masteries.craftMasteryDatas.values {
            description.append("\(masteryData.dstType): \(masteryData.lv)\n")
        }

        return description
    }

}
