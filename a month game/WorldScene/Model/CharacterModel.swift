//
//  CharacterController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation

class CharacterModel {

    private let service: WorldDataService

    var tileCoord: TileCoordinate
    var position: CGPoint { self.tileCoord.fieldPoint }

    // MARK: init
    init(service: WorldDataService) {
        self.service = service

        let x = service.load(at: .characterX)
        let y = service.load(at: .characterY)
        self.tileCoord = TileCoordinate(x, y)
    }

}
