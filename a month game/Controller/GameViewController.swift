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

        let gameController = GameController()

        let gameModel = GameModel()
        let gameScene = GameScene()
        gameController.gameModel = gameModel
        gameController.gameScene = gameScene
        gameScene.gameController = gameController

        gameScene.size = Constant.screenSize
        gameScene.scaleMode = .aspectFit

        self.gameController = gameController

        let view = self.view as! SKView
        view.presentScene(gameScene)
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
