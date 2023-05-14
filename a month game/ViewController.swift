//
//  ViewController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import UIKit
import SpriteKit
import GameplayKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    var sceneController: SceneController!

    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
        setPortalScene()
        testCode()
    }

    func testCode() {
    }

    func setView() {
        let view = self.view as! SKView
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }

    func setPortalScene() {
        let sceneController = PortalSceneController(viewController: self)

        let view = self.view as! SKView
        view.presentScene(sceneController.scene)
        self.sceneController = sceneController
    }

    func setWorldScene() {
        let sceneController = WorldSceneController(viewController: self, worldName: Constant.defaultWorldName)

        let view = self.view as! SKView
        view.presentScene(sceneController.scene)
        self.sceneController = sceneController
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
