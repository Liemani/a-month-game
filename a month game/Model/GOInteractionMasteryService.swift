//
//  InteractionMasteryService.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/09.
//

import Foundation

class GOInteractionMasteryService {
    
    func load() -> [GOInteractionMasteryData] {
        let mos = Repositories.default.goInteractionMasteryDS.load()

        let datas = mos.compactMap { GOInteractionMasteryData(from: $0) }
        return datas
    }

}
