//
//  WorldViewController.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/11.
//

import UIKit
import SpriteKit
import GameplayKit

class WorldViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setView()
        self.setScene()

        NotificationCenter.default.addObserver(self, selector: #selector(requestPresentPortalViewController), name: .requestPresentPortalViewController, object: nil)
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
        let worldScene = WorldScene()
        worldScene.setUp(worldName: Constant.defaultWorldName)

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

    @objc
    func requestPresentPortalViewController() {
        let portalViewController = storyboard?.instantiateViewController(identifier: "PortalViewController") as! PortalViewController
        self.navigationController?.setViewControllers([portalViewController], animated: false)
    }

}
