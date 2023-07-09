//
//  GameObjectModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/18.
//

import Foundation

struct GameObjectState: OptionSet {

    let rawValue: Int16

}

class GameObjectData {

    weak var go: GameObject?
    private var mo: GameObjectMO

    var id: Int { Int(self.mo.id) }

    var type: GameObjectType
    func set(type goType: GameObjectType) {
        self.mo.update(to: goType)
        self.type = goType
    }

    var variant: Int
    func set(variant: Int) {
        self.mo.update(to: variant)
        self.variant = variant
    }

    var quality: Double {
        get { self.mo.quality }
        set { self.mo.quality = newValue }
    }

    var state: GameObjectState
    func insert(state: GameObjectState) {
        self.state.insert(state)
        self.mo.update(to: state)
    }
    func remove(state: GameObjectState) {
        self.state.remove(state)
        self.mo.update(to: state)
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
    init(goType: GameObjectType,
         variant: Int,
         quality: Double,
         state: GameObjectState) {
        let id = ServiceContainer.default.idGeneratorServ.generate()
        self.mo = ServiceContainer.default.goRepo.new(id: id,
                                                      type: goType,
                                                      variant: variant,
                                                      quality: quality,
                                                      state: state)

        self.type = goType
        self.variant = variant

        self.state = state

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

        self.state = GameObjectState(rawValue: goMO.state)

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
