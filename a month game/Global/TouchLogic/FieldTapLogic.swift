//
//  FieldTouchLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation
import SpriteKit

class FieldTapLogic: TouchLogic {

    var touch: UITouch { self.touches[0] }
    private let bChunkCoord: ChunkCoordinate

    init(touch: UITouch) {
        self.bChunkCoord = Logics.default.chunkContainer.coordAtLocation(of: touch)!

        super.init()

        self.touches.append(touch)
    }

    override func ended() {
        guard let chunkCoord = Logics.default.chunkContainer.coordAtLocation(of: self.touch) else {
            return
        }

        guard chunkCoord == self.bChunkCoord else {
            return
        }

        if let activatedGO = TouchLogics.default.activatedGO {
            if let go = Logics.default.chunkContainer.item(at: chunkCoord) {
                TouchLogics.default.freeActivatedGO()
                activatedGO.interact(to: go)
            } else {
                TouchLogics.default.freeActivatedGO()
                activatedGO.move(to: chunkCoord)
            }

            return
        }

        if let go = Logics.default.chunkContainer.item(at: chunkCoord) {
            go.interact()

            return
        }

        if Logics.default.invContainer.is(equiping: .shovel) {
            GameObject.new(type: .dirtTile, coord: chunkCoord)

            return
        }
    }

}
