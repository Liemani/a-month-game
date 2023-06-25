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

        NotificationCenter.default.addObserver(self, selector: #selector(requestPresentWorldSceneViewController), name: .requestPresentWorldSceneViewController, object: nil)
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
    func requestPresentWorldSceneViewController() {
        WorldServiceContainer.set(worldName: Constant.Name.defaultWorld)
        TouchEventHandlerManager.set()
        EventManager.set()
        WorldUpdateManager.set()

        let worldViewController = self.storyboard!.instantiateViewController(identifier: "WorldViewController") as! WorldViewController

        self.navigationController?.setViewControllers([worldViewController], animated: false)
    }

}
