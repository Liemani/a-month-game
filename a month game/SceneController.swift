//
//  SceneController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/14.
//

import SpriteKit

class SceneController {

    weak var viewController: ViewController!

    var scene: SKScene!

    // must init scene in subclass
    required init(viewController: ViewController) {
        self.viewController = viewController
    }

}
