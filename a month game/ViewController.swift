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

    var fileController: FileController!

    var portalController: PortalController?
    var worldController: WorldController?

    override func viewDidLoad() {
        super.viewDidLoad()

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
        worldController = nil
        let portalController = PortalController()
        portalController.viewController = self
        let view = self.view as! SKView
        view.presentScene(portalController.portalScene)
        self.portalController = portalController
    }

    func setWorldScene() {
        portalController = nil
        let worldController = WorldController(viewController: self, worldName: Constant.defaultWorldName)
        let view = self.view as! SKView
        view.presentScene(worldController.worldScene)
        self.worldController = worldController
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
