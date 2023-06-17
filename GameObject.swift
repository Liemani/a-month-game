//
//  GameObjectModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/18.
//

import Foundation

class GameObject {

    private let goRepository: GameObjectRepository

    private var mo: GameObjectMO

    let id: Int
    let type: GameObjectType

    private var _coord: Coordinate<Int>?
    var coord: Coordinate<Int>? { self._coord }
    func setCoord(coord: Coordinate<Int>) {
        self._invCoord = nil
        self._coord = coord
        self.goRepository.update(self.mo, coord: coord)
    }

    private var _invCoord: InventoryCoordinate?
    var invCoord: InventoryCoordinate? { self._invCoord }
    func setInvCoord(invCoord: InventoryCoordinate) {
        self._coord = nil
        self._invCoord = invCoord
        self.goRepository.update(self.mo, invCoord: invCoord)
    }

    init(goRepository: GameObjectRepository, id: Int, type: GameObjectType, coord: Coordinate<Int>) {
        self.goRepository = goRepository
        self.mo = goRepository.new(id: id, type: type, coord: coord)
        self.id = id
        self.type = type
        self._coord = coord
    }

    init(goRepository: GameObjectRepository, id: Int, type: GameObjectType, invCoord: InventoryCoordinate) {
        self.goRepository = goRepository
        self.mo = goRepository.new(id: id, type: type, invCoord: invCoord)
        self.id = id
        self.type = type
        self._invCoord = invCoord
    }

    init?(goRepository: GameObjectRepository, from goMO: GameObjectMO) {
        self.goRepository = goRepository
        self.mo = goMO
        self.id = Int(goMO.id)

        let typeID = Int(goMO.typeID)
        guard let type = GameObjectType(rawValue: typeID) else {
            return nil
        }

        self.type = type
        self._coord = nil
        self._invCoord = nil

        if let chunkCoordMO = goMO.chunkCoord {
            let chunkCoord = ChunkCoordinate(from: chunkCoordMO)
            self._coord = chunkCoord.coord
        }

        if let invCoordMO = goMO.invCoord {
            let invCoord = InventoryCoordinate(from: invCoordMO)
            self._invCoord = invCoord
        }

        if (self._coord == nil) == (self._invCoord == nil) {
            return nil
        }
    }

    func delete() {
        self.goRepository.delete(self.mo)
    }

}
