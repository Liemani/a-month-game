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
        let coord = Services.default.chunkContainer.target.coordAtLocation(of: touch)!
        let chunkCoord = Services.default.chunkContainer.chunkCoord(coord)

        self.bChunkCoord = chunkCoord

        super.init()

        self.touches.append(touch)
    }

    override func ended() {
        guard let coord = Services.default.chunkContainer.target.coordAtLocation(of: self.touch) else {
            return
        }

        let chunkCoord = Services.default.chunkContainer.chunkCoord(coord)

        guard chunkCoord == self.bChunkCoord else {
            return
        }

        if let activatedGO = TouchServices.default.activatedGO {
            if let go = Services.default.chunkContainer.item(at: chunkCoord) {
                TouchServices.default.freeActivatedGO()
                activatedGO.interact(to: go)
            } else {
                TouchServices.default.freeActivatedGO()
                activatedGO.move(to: chunkCoord)
            }

            return
        }

        if let go = Services.default.chunkContainer.item(at: chunkCoord) {
            go.interact()

            return
        }

        if Logics.default.invContainer.is(equiping: .shovel) {
            _ = GameObject.new(type: .dirtFloor, coord: chunkCoord)

            return
        }
    }

}
