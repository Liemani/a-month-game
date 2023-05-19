//
//  CharacterCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/19.
//

import Foundation

class CharacterCoordinate {

    var x: Int
    var y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    func toCGPoint() -> CGPoint {
        return CGPoint(x: self.x, y: self.y)
    }

}
