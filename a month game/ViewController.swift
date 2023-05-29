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

    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
        setPortalScene()
    }

    func setView() {
        let view = self.view as! SKView
        view.ignoresSiblingOrder = true
#if DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
#endif
    }

    func setPortalScene() {
        let portalScene = PortalScene()
        portalScene.setUp(viewController: self)

        let view = self.view as! SKView
        view.presentScene(portalScene.scene)
    }

    func setWorldScene() {
        let worldScene = WorldScene()
        worldScene.setUp(viewController: self, worldName: Constant.defaultWorldName)

        let view = self.view as! SKView
        view.presentScene(worldScene)
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
