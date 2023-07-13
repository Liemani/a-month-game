//
//  InteractionMasteryService.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/09.
//

import Foundation

class GOInteractionMasteryService {
    
    private let dataSource: GOInteractionMasteryDataSource

    init(dataSource: GOInteractionMasteryDataSource) {
        self.dataSource = dataSource
    }

    func load() -> [GOInteractionMasteryData] {
        let mos = self.dataSource.load()

        let datas = mos.compactMap { GOInteractionMasteryData(from: $0) }
        return datas
    }

}
