//
//  FieldTouchHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation
import SpriteKit

class FieldTouchHandler {

    var invContainer: InventoryContainer
    var chunkContainer: ChunkContainer

    var touch: UITouch!
    var bChunkCoord: ChunkCoordinate!

    init(invContainer: InventoryContainer, chunkContainer: ChunkContainer) {
        self.invContainer = invContainer
        self.chunkContainer = chunkContainer
    }

}

extension FieldTouchHandler: TouchEventHandler {

    func began(touch: UITouch) {
        self.touch = touch
        self.bChunkCoord = self.chunkContainer.coordAtLocation(of: touch)
    }

    func moved() {
    }

    func ended() {
        let chunkCoord = self.chunkContainer.coordAtLocation(of: self.touch)!
        guard chunkCoord == self.bChunkCoord else {
            self.complete()

            return
        }

        if let activatedGO = TouchHandlerContainer.default.activatedGO {
            GameObjectManager.default.removeFromParent(activatedGO)
            activatedGO.data.set(coord: chunkCoord)
            GameObjectManager.default.addToBelongField(activatedGO)

            activatedGO.deactivate()
            TouchHandlerContainer.default.activatedGO = nil
            self.complete()

            return
        }

        if self.invContainer.is(equiping: .stoneShovel) {
            GameObjectManager.default.new(type: .dirtTile, chunkCoord: chunkCoord)

            return
        }

        self.complete()

        return
    }

    func cancelled() {
        self.complete()
    }

    func complete() {
        self.touch = nil
    }

}
