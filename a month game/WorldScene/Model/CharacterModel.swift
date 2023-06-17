//
//  CharacterController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation

class CharacterModel {

    private let worldDataRepository: WorldDataRepository

    var coord: Coordinate<Int>
    var position: CGPoint { TileCoordinate(self.coord).fieldPoint }

    // MARK: init
    init(worldDataRepository: WorldDataRepository) {
        self.worldDataRepository = worldDataRepository

        let x = worldDataRepository.load(at: .characterPositionX)
        let y = worldDataRepository.load(at: .characterPositionY)
        self.coord = Coordinate<Int>(x, y)
    }

    func set(coord: Coordinate<Int>) {
        self.worldDataRepository.update(value: coord.x, to: .characterPositionX)
        self.worldDataRepository.update(value: coord.y, to: .characterPositionY)
    }

}
