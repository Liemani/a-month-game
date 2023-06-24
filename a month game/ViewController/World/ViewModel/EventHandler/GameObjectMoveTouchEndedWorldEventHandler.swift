//
//  GameObjectMoveWorldEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/24.
//

import Foundation
import SpriteKit

class GameObjectMoveTouchEndedWorldEventHandler {

    let touch: UITouch

    let go: GameObject

    let chunkContainer: ChunkContainer

    init(touch: UITouch, go: GameObject, chunkContainer: ChunkContainer) {
        self.touch = touch
        self.go = go
        self.chunkContainer = chunkContainer
    }

    func handle() {
        if self.chunkContainer.itemAtLocation(of: touch) == nil {
            self.go.setUpPosition()
            self.go.removeFromParent()
            print("if in field put it there")
            let event = WorldEvent(type: .gameObjectAddToChunk,
                                    udata: nil,
                                    sender: self.go)
            WorldEventManager.default.enqueue(event)
            print("else to inventory")
            return
        }

//          if touch not intersect with any object {
//              let tileCoord = touch tile coord
//                  if the tile is in accessable range {
//                      go.put(tileCoord)
//                  }
//          }
        self.go.removeFromParent()
        self.go.setUpPosition()
        let event = WorldEvent(type: .gameObjectAddToChunk,
                               udata: nil,
                               sender: self.go)
        WorldEventManager.default.enqueue(event)

        print("if touch is puttable put else cancel")
    }

}
