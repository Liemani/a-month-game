//
//  InteractionMasteryService.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/09.
//

import Foundation

class InteractionMasteryService {

    private let dataSource: InteractionMasteryDataSource

    init(dataSource: InteractionMasteryDataSource) {
        self.dataSource = dataSource
    }

    func load() -> [InteractionMasteryData] {
        let mos = self.dataSource.load()

        let datas = mos.compactMap { InteractionMasteryData(from: $0) }
        return datas
    }

}
