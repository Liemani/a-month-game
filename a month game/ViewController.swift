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

    var persistentContainer: PersistentContainer!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard persistentContainer != nil else {
            fatalError("This view needs a persistent container.")
        }

        setView()
        setPortalScene()
    }

    func setView() {
        let view = self.view as! SKView
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }

    func setPortalScene() {
        let portalController = PortalSceneController(viewController: self)

        let view = self.view as! SKView
        view.presentScene(portalController.portalScene)
    }

    func setWorldScene() {
        let worldController = WorldSceneController(viewController: self, worldName: Constant.defaultWorldName)

        let view = self.view as! SKView
        view.presentScene(worldController.worldScene)
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
