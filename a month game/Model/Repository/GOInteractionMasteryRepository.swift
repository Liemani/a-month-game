//
//  GOInteractionMasteryRepository.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/10.
//

import Foundation

class GOInteractionMasteryRepository {

    private let goInteractionMasteryDS: GOInteractionMasteryDataSource

    init(goInteractionMasteryDS: GOInteractionMasteryDataSource) {
        self.goInteractionMasteryDS = goInteractionMasteryDS
    }

    func new(from srcType: GameObjectType, to dstType: GameObjectType) -> GOInteractionMasteryMO {
        let mo = self.goInteractionMasteryDS.new()

        mo.srcTypeID = Int32(srcType.rawValue)
        mo.dstTypeID = Int32(dstType.rawValue)
        mo.exp = 0

        return mo
    }

}

extension GOInteractionMasteryMO {

    func update(increment expIncrement: Int32) {
        self.exp += expIncrement
    }

}
