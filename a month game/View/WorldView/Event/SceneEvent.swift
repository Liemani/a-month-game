//
//  SceneEvent.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation

enum SceneEventType {

    case characterHasMovedToAnotherTile
    case characterHasMovedToAnotherChunk

}

class SceneEvent {

    let type: SceneEventType
    let udata: Any?

    let sender: Any

    init(type: SceneEventType, udata: Any?, sender: Any) {
        self.type = type
        self.udata = udata
        self.sender = sender
    }

}
