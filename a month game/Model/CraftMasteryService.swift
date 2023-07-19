//
//  CraftMasteryService.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/09.
//

import Foundation

class CraftMasteryService {

    func load() -> [CraftMasteryData] {
        let mos = Repositories.default.craftMasteryDS.load()

        let datas = mos.compactMap { CraftMasteryData(from: $0) }
        return datas
    }

}
