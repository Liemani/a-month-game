//
//  InteractionMasteryService.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/09.
//

import Foundation

class InteractionMasteryService {

    func load() -> [InteractionMasteryData] {
        let mos = Repositories.default.interactionMasteryDS.load()

        let datas = mos.compactMap { InteractionMasteryData(from: $0) }
        return datas
    }

}
