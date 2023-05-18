//
//  WorldSceneController+EventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/18.
//

import Foundation
import SpriteKit

extension WorldSceneController: GameObjectDelegate {

    // TODO: implement
    func interact(_ gameObject: GameObject, with leftHand: GameObject?, and rightHand: GameObject?) {
        print("GameObjectDelegate.interact(\(gameObject))")
    }

}
