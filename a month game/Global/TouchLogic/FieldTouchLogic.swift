//
//  FieldTouchLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation
import SpriteKit

class FieldTapLogic {

    let touch: UITouch
    private let bChunkCoord: ChunkCoordinate

    init(touch: UITouch) {
        self.touch = touch
        self.bChunkCoord = Logics.default.chunkContainer.coordAtLocation(of: touch)!
    }

}

extension FieldTapLogic: TouchLogic {

    func began() {
    }

    func moved() {
    }

    func ended() {
        let chunkCoord = Logics.default.chunkContainer.coordAtLocation(of: self.touch)!

        guard chunkCoord == self.bChunkCoord else {
            return
        }

        if let activatedGO = Logics.default.touch.activatedGO {
            if let go = Logics.default.chunkContainer.item(at: chunkCoord) {
                Logics.default.touch.freeActivatedGO()
                Logics.default.go.interactToGO(activatedGO, to: go)
            } else {
                Logics.default.touch.freeActivatedGO()
                Logics.default.scene.move(activatedGO, to: chunkCoord)
            }

            return
        }

        if let go = Logics.default.chunkContainer.item(at: chunkCoord) {
            Logics.default.go.interact(go)

            return
        }

        if Logics.default.invContainer.is(equiping: .shovel) {
            Logics.default.go.new(type: .dirtTile,
                                          coord: chunkCoord)

            return
        }
    }

    func cancelled() {
    }

}
