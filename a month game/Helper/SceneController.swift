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

    init(viewController: ViewController) {
        self.viewController = viewController
    }

}
