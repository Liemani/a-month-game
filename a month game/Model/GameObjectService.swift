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
        let id = Services.default.idGeneratorServ.generate()

        let mo = Services.default.goRepo.new(id: id,
                                             type: goType,
                                             variant: 0,
                                             quality: 0.0,
                                             state: [])
        mo.update(to: chunkCoord)

        return mo
    }

}
