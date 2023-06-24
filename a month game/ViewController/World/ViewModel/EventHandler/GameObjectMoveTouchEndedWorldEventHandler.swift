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
        if let touchedGo = self.chunkContainer.goAtLocation(of: touch) {
            self.go.setUpPosition()
            return
        }

//          if touch not intersect with any object {
//              let tileCoord = touch tile coord
//                  if the tile is in accessable range {
//                      go.put(tileCoord)
//                  }
//          }

        print("if touch is puttable put else cancel")
    }

}
