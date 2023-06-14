//
//  ViewController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import UIKit
import SpriteKit
import GameplayKit

class PortalViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setView()
        self.setScene()

        NotificationCenter.default.addObserver(self, selector: #selector(requestPresentWorldViewController), name: .requestPresentWorldViewController, object: nil)
    }

    func setView() {
        let view = self.view as! SKView
        view.ignoresSiblingOrder = true
#if DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
#endif
    }

    func setScene() {
        let portalScene = PortalScene()
        portalScene.setUp()

        let view = self.view as! SKView
        view.presentScene(portalScene)
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

    @objc
    func requestPresentWorldViewController() {
        let worldViewController = storyboard?.instantiateViewController(identifier: "WorldViewController") as! WorldViewController
        let worldDataContainer = WorldDataContainer(worldName: Constant.defaultWorldName)
        worldViewController.setUp(worldDataContainer: worldDataContainer)
        self.navigationController?.setViewControllers([worldViewController], animated: false)
    }

}
