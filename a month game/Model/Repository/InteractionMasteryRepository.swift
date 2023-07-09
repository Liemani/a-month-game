//
//  InteractionMasteryRepository.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/10.
//

import Foundation

class InteractionMasteryRepository {

    private let interactionMasteryDS: InteractionMasteryDataSource

    init(interactionMasteryDS: InteractionMasteryDataSource) {
        self.interactionMasteryDS = interactionMasteryDS
    }

    func new(type goType: GameObjectType) -> InteractionMasteryMO {
        let mo = self.interactionMasteryDS.new()

        mo.dstTypeID = Int32(goType.rawValue)
        mo.exp = 0

        return mo
    }

}

extension InteractionMasteryMO {

    func update(increment expIncrement: Int32) {
        self.exp += expIncrement
    }

}
