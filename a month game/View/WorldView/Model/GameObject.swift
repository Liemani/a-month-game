//
//  GameObjectModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/18.
//

import Foundation

class GameObject {

    private var mo: GameObjectMO

    var id: Int { Int(self.mo.id) }
    var type: GameObjectType { GameObjectType(from: self.mo)! }

    private var _chunkCoord: ChunkCoordinate?
    var chunkCoord: ChunkCoordinate? { self._chunkCoord }
    func set(chunkCoord: ChunkCoordinate) {
        self._chunkCoord = chunkCoord
        self._invCoord = nil

        self.mo.update(to: chunkCoord)
    }

    private var _invCoord: InventoryCoordinate?
    var invCoord: InventoryCoordinate? { self._invCoord }
    func set(invCoord: InventoryCoordinate) {
        self._chunkCoord = nil
        self._invCoord = invCoord

        self.mo.update(to: invCoord)
    }

    // MARK: - init
    init(type: GameObjectType) {
        let id = WorldServiceContainer.default.idGeneratorServ.generate()
        self.mo = WorldServiceContainer.default.goRepo.new(id: id, type: type)
        self._chunkCoord = nil
        self._invCoord = nil
    }

    init?(from goMO: GameObjectMO) {
        self.mo = goMO

        guard let type = GameObjectType(from: goMO) else {
            return nil
        }

        self._chunkCoord = nil
        self._invCoord = nil

        if let chunkCoordMO = goMO.chunkCoord {
            self._chunkCoord = ChunkCoordinate(from: chunkCoordMO)
        }

        if let invCoordMO = goMO.invCoord {
            self._invCoord = InventoryCoordinate(from: invCoordMO)
        }

        if (self._chunkCoord == nil) == (self._invCoord == nil) {
            return nil
        }
    }

    func delete() {
        self.mo.delete()
    }

}
