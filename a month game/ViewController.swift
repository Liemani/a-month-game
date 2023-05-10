//
//  ViewController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import UIKit
import SpriteKit
import GameplayKit

class ViewController: UIViewController {

    var portalController: PortalController!
    var worldController: WorldController!

    override func viewDidLoad() {
        super.viewDidLoad()

        let view = self.view as! SKView
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true

        setPortalScene()
    }

    func setWorldScene() {
        let worldController = WorldController()
        let view = self.view as! SKView
        view.presentScene(worldController.worldScene)
        self.worldController = worldController
    }

    func setPortalScene() {
        let portalController = PortalController()
        let view = self.view as! SKView
        view.presentScene(portalController.portalScene)
        self.portalController = portalController
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
