//
//  CraftLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/13.
//

import Foundation

class CraftLogic {

    func craft(_ craftObject: CraftObject) {
        let consumeTargets = craftObject.consumeTargets
        var sum = 0.0

        for go in consumeTargets {
            go.delete()
            sum += go.quality
        }

        let result = Logics.default.mastery.craft(craftObject.goType)

        let emptyCoord = Logics.default.invContainer.emptyCoord!
        Logics.default.scene.new(result: result,
                                 type: craftObject.goType,
                                 quality: sum / Double(consumeTargets.count),
                                 coord: emptyCoord)
    }

}
