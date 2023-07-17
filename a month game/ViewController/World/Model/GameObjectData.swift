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

    private var _type: GameObjectType
    var type: GameObjectType {
        get { self._type }
        set {
            self._type = newValue

            self.mo.update(type: newValue)
            self.mo.updateDateLastChanged()
        }
    }

    private var _variant: Int
    var variant: Int {
        get { self._variant }
        set {
            self._variant = newValue

            self.mo.update(variant: newValue)
            self.mo.updateDateLastChanged()
        }
    }

    var quality: Double {
        get { self.mo.quality }
        set {
            self.mo.update(quality: newValue)
            self.mo.updateDateLastChanged()
        }
    }

    private var _state: GameObjectState
    var state: GameObjectState { return self._state }
    func insert(state: GameObjectState) {
        self._state.insert(state)

        self.mo.update(state: state)
        self.mo.updateDateLastChanged()
    }
    func remove(state: GameObjectState) {
        self._state.remove(state)

        self.mo.update(state: state)
        self.mo.updateDateLastChanged()
    }

    private var _chunkCoord: ChunkCoordinate?
    var chunkCoord: ChunkCoordinate? { self._chunkCoord }
    func set(coord chunkCoord: ChunkCoordinate) {
        self._invCoord = nil
        self._chunkCoord = chunkCoord

        self.mo.update(coord: chunkCoord)
        self.mo.updateDateLastChanged()
    }

    private var _invCoord: InventoryCoordinate?
    var invCoord: InventoryCoordinate? { self._invCoord }
    func set(coord invCoord: InventoryCoordinate) {
        self._chunkCoord = nil
        self._invCoord = invCoord

        self.mo.update(coord: invCoord)
        self.mo.updateDateLastChanged()
    }

    var dateLastChanged: Date { self.mo.dateLastChanged! }
    func setDateLastChanged() {
        self.mo.updateDateLastChanged()
    }

    // MARK: - init
    init(goType: GameObjectType,
         variant: Int,
         quality: Double,
         state: GameObjectState) {
        let id = Services.default.idGeneratorServ.generate()
        self.mo = Services.default.goRepo.new(id: id,
                                              type: goType,
                                              variant: variant,
                                              quality: quality,
                                              state: state)

        self._type = goType
        self._variant = variant

        self._state = state

        self._chunkCoord = nil
        self._invCoord = nil
    }

    init?(from goMO: GameObjectMO) {
        guard let goType = GameObjectType(from: goMO) else {
            return nil
        }

        self.mo = goMO
        self._type = goType
        self._variant = goMO.variant

        self._state = GameObjectState(rawValue: goMO.state)

        self._chunkCoord = nil
        self._invCoord = nil

        if let chunkCoordMO = goMO.chunkCoord {
            let chunkAddress = UInt16(truncatingIfNeeded: UInt32(bitPattern: chunkCoordMO.address))
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
