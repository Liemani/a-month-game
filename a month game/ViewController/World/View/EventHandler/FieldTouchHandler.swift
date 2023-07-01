//
//  FieldTouchHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation
import SpriteKit

class FieldTouchHandler {

    var chunkContainer: ChunkContainer

    var touch: UITouch!
    var bChunkCoord: ChunkCoordinate!

    init(chunkContainer: ChunkContainer) {
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
            activatedGO.data.set(chunkCoord: chunkCoord)

            let event = Event(type: WorldEventType.gameObjectMoveToBelongField,
                              udata: nil,
                              sender: activatedGO)
            WorldEventManager.default.enqueue(event)

            activatedGO.deactivate()
            TouchHandlerContainer.default.activatedGO = nil
            self.complete()

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
