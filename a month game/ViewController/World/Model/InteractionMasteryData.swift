//
//  InteractionMasteryData.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/09.
//

import Foundation

class InteractionMasteryData {
    
    private let mo: InteractionMasteryMO

    let dstType: GameObjectType

    var exp: Int32 { self.mo.exp }

    init?(from interactionMasteryMO: InteractionMasteryMO) {
        guard let dstType = GameObjectType(rawValue: Int(interactionMasteryMO.dstTypeID)) else {
            return nil
        }

        self.dstType = dstType

        self.mo = interactionMasteryMO
    }

    init(type goType: GameObjectType) {
        self.mo = Services.default.interactionMasteryRepo.new(type: goType)

        self.dstType = goType
    }

    func increase(exp: Int32) {
        self.mo.update(increment: exp)
    }

}
