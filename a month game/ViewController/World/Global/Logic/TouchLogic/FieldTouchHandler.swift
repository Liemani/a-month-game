//
//  FieldTouchLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation
import SpriteKit

class FieldTouchLogic {

    let touch: UITouch
    private let bChunkCoord: ChunkCoordinate

    init(touch: UITouch) {
        self.touch = touch
        self.bChunkCoord = LogicContainer.default.chunkContainer.coordAtLocation(of: touch)!
    }

}

extension FieldTouchLogic: TouchLogic {

    func began() {
    }

    func moved() {
    }

    func ended() {
        let chunkCoord = LogicContainer.default.chunkContainer.coordAtLocation(of: self.touch)!
        guard chunkCoord == self.bChunkCoord else {
            return
        }

        if let activatedGO = LogicContainer.default.touch.activatedGO {
            LogicContainer.default.scene.removeFromParent(activatedGO)
            activatedGO.data.set(coord: chunkCoord)
            LogicContainer.default.scene.addToBelongField(activatedGO)

            activatedGO.deactivate()
            LogicContainer.default.touch.activatedGO = nil

            return
        }

        if LogicContainer.default.invContainer.is(equiping: .stoneShovel) {
            LogicContainer.default.scene.new(type: .dirtTile, chunkCoord: chunkCoord)

            return
        }

        return
    }

    func cancelled() {
    }

}
