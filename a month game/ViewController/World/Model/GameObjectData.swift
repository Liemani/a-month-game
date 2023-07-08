//
//  GameObjectModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/18.
//

import Foundation

class GameObjectData {

    weak var go: GameObject?
    private var mo: GameObjectMO

    var id: Int { Int(self.mo.id) }
    var type: GameObjectType
    var variant: Int

    func set(type goType: GameObjectType) {
        self.mo.update(to: goType)
        self.type = goType
    }

    func set(variant: Int) {
        self.mo.update(to: variant)
        self.variant = variant
    }

    private var _chunkCoord: ChunkCoordinate?
    var chunkCoord: ChunkCoordinate? { self._chunkCoord }
    func set(coord chunkCoord: ChunkCoordinate) {
        self._chunkCoord = chunkCoord
        self._invCoord = nil

        self.mo.update(to: chunkCoord)
    }

    private var _invCoord: InventoryCoordinate?
    var invCoord: InventoryCoordinate? { self._invCoord }
    func set(coord invCoord: InventoryCoordinate) {
        self._chunkCoord = nil
        self._invCoord = invCoord

        self.mo.update(to: invCoord)
    }

    // MARK: - init
    init(goType: GameObjectType, variant: Int) {
        let id = ServiceContainer.default.idGeneratorServ.generate()
        self.mo = ServiceContainer.default.goRepo.new(id: id, type: goType, variant: variant)
        self.type = goType
        self.variant = variant
        self._chunkCoord = nil
        self._invCoord = nil
    }

    init?(from goMO: GameObjectMO) {
        guard let goType = GameObjectType(from: goMO) else {
            return nil
        }

        self.mo = goMO
        self.type = goType
        self.variant = goMO.variant

        self._chunkCoord = nil
        self._invCoord = nil

        if let chunkCoordMO = goMO.chunkCoord {
            let chunkAddress = UInt16(truncatingIfNeeded: UInt32(bitPattern: chunkCoordMO.location))
            self._chunkCoord = ChunkCoordinate(x: chunkCoordMO.x,
                                               y: chunkCoordMO.y,
                                               chunkAddress: chunkAddress)
        }

        if let invCoordMO = goMO.invCoord {
            let id = Int(invCoordMO.id)
            let index = Int(invCoordMO.index)
            self._invCoord = InventoryCoordinate(id, index)
        }

        if (self._chunkCoord == nil) == (self._invCoord == nil) {
            return nil
        }
    }

    func delete() {
        self.mo.delete()
    }

}
