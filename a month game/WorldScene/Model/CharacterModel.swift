//
//  CharacterController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation

class CharacterModel {

    var coordinate: TileCoordinate

    init() {
        // TODO: load coordinate
//        self.coordinate = CharacterCoordinate(x: 49, y: 49)
        self.coordinate = TileCoordinate(x: 0, y: 0)
    }

}
