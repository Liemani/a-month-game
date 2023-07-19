//
//  GameObjectService.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/15.
//

import Foundation

class GameObjectService {

    func newMO(type goType: GameObjectType,
               coord chunkCoord: ChunkCoordinate) -> GameObjectMO {
        let id = Services.default.idGenerator.generate()

        let mo = Repositories.default.goRepo.new(id: id,
                                             type: goType,
                                             variant: 0,
                                             quality: 0.0,
                                             state: [],
                                             date: Date())
        mo.update(coord: chunkCoord)

        return mo
    }

}
