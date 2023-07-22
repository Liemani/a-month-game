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

    override func began() {
        Services.default.chunkContainer
            .item(at: self.bChunkCoord)?
            .activate()
    }

    override func moved() {
        guard let coord = Services.default.chunkContainer.target.coordAtLocation(of: self.touch) else {
            Services.default.chunkContainer
                .item(at: self.bChunkCoord)?
                .deactivate()
            return
        }

        let go = Services.default.chunkContainer
            .item(at: self.bChunkCoord)

        let chunkCoord = Services.default.chunkContainer.chunkCoord(coord)

        if chunkCoord == self.bChunkCoord {
            go?.activate()
        } else {
            go?.deactivate()
        }
    }

    override func ended() {
        guard let coord = Services.default.chunkContainer.target.coordAtLocation(of: self.touch) else {
            return
        }

        let go = Services.default.chunkContainer
            .item(at: self.bChunkCoord)

        let chunkCoord = Services.default.chunkContainer.chunkCoord(coord)

        guard chunkCoord == self.bChunkCoord else {
            go?.deactivate()
            return
        }

        if let activatedGO = TouchServices.default.activatedGO {
            activatedGO.deactivate()
            go?.deactivate()

            if let go = go {
                if activatedGO == go {
                    go.interact()
                } else {
                    activatedGO.interact(to: go)
                }

                TouchServices.default.activatedGO = nil
            } else {
                TouchServices.default.freeActivatedGO()
                activatedGO.move(to: chunkCoord)
            }

            return
        }

        if let go = go {
            if go.isOnField
                && !go.type.isMovable {
                go.interact()
                go.deactivate()

                return
            }

            TouchServices.default.activatedGO = go

            return
        }

        if Logics.default.invContainer.is(equiping: .shovel) {
            _ = GameObject.new(type: .dirtFloor, coord: chunkCoord)

            return
        }
    }

}
