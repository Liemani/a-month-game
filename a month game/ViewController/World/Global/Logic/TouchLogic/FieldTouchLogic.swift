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
            if let go = LogicContainer.default.chunkContainer.item(at: chunkCoord) {
                LogicContainer.default.touch.freeActivatedGO()
                LogicContainer.default.go.interactToGO(activatedGO, to: go)
            } else {
                LogicContainer.default.touch.freeActivatedGO()
                LogicContainer.default.scene.move(activatedGO, to: chunkCoord)
            }

            return
        }

        if let go = LogicContainer.default.chunkContainer.item(at: chunkCoord) {
            LogicContainer.default.go.interact(go)

            return
        }

        if LogicContainer.default.invContainer.is(equiping: .stoneShovel) {
            LogicContainer.default.go.new(type: .dirtTile, coord: chunkCoord)

            return
        }
    }

    func cancelled() {
    }

}
