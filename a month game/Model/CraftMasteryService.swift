//
//  CraftMasteryService.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/09.
//

import Foundation

class CraftMasteryService {

    private let dataSource: CraftMasteryDataSource

    init(dataSource: CraftMasteryDataSource) {
        self.dataSource = dataSource
    }

    func load() -> [CraftMasteryData] {
        let mos = self.dataSource.load()

        let datas = mos.compactMap { CraftMasteryData(from: $0) }
        return datas
    }

}
