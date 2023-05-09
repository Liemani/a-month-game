//
//  GameViewController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var gameController: GameController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.gameController = GameController()

        let view = self.view as! SKView
        view.presentScene(self.gameController.gameScene)
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
