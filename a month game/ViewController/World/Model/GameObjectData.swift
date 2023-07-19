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
        }
    }

    private var _variant: Int
    var variant: Int {
        get { self._variant }
        set {
            self._variant = newValue

            self.mo.update(variant: newValue)
        }
    }

    var quality: Double {
        get { self.mo.quality }
        set {
            self.mo.update(quality: newValue)
        }
    }

    private var _state: GameObjectState
    var state: GameObjectState { return self._state }
    func insert(state: GameObjectState) {
        self._state.insert(state)

        self.mo.update(state: state)
    }
    func remove(state: GameObjectState) {
        self._state.remove(state)

        self.mo.update(state: state)
    }

    private var _chunkCoord: ChunkCoordinate?
    var chunkCoord: ChunkCoordinate? { self._chunkCoord }
    func set(coord chunkCoord: ChunkCoordinate) {
        self._invCoord = nil
        self._chunkCoord = chunkCoord

        self.mo.update(coord: chunkCoord)
    }

    private var _invCoord: InventoryCoordinate?
    var invCoord: InventoryCoordinate? { self._invCoord }
    func set(coord invCoord: InventoryCoordinate) {
        self._chunkCoord = nil
        self._invCoord = invCoord

        self.mo.update(coord: invCoord)
    }

    var dateLastChanged: Date {
        get { self.mo.dateLastChanged! }
        set {
            self.mo.update(dateLastChanged: newValue)

            self._setTimeEventDateByDateLastChanged()
        }
    }

    var timeEventDate: Date?

    private func _setTimeEventDateByDateLastChanged() {
        let actionTimeout = self.type.actionTimeout

        self.timeEventDate = (actionTimeout != -1)
                                ? self.dateLastChanged + actionTimeout
                                : nil
    }

    // MARK: - init
    init(goType: GameObjectType,
         variant: Int,
         quality: Double,
         state: GameObjectState,
         date: Date) {
        let id = Services.default.idGenerator.generate()
        self.mo = Repositories.default.goRepo.new(id: id,
                                              type: goType,
                                              variant: variant,
                                              quality: quality,
                                              state: state,
                                              date: date)

        self._type = goType
        self._variant = variant

        self._state = state

        self._chunkCoord = nil
        self._invCoord = nil

        self._setTimeEventDateByDateLastChanged()
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

        self._setTimeEventDateByDateLastChanged()
    }

    func delete() {
        self.mo.delete()
    }

}
