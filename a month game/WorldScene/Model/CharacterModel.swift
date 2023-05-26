//
//  CharacterController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation

class CharacterModel {

    private var tileCoordinate: TileCoordinate

    init() {
        // TODO: 99 load coordinate
        self.tileCoordinate = TileCoordinate(49, 49)
    }

    var position: CGPoint {
        return self.tileCoordinate.fieldPoint
    }

}
