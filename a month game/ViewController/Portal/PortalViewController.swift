//
//  ViewController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import UIKit
import SpriteKit
import GameplayKit

class PortalViewController: UIViewController {

    private var skView: SKView { return self.view as! SKView }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setView()

        let scene = PortalScene()
        self.skView.presentScene(scene)

        self.configureTouchManager(scene: scene)

        NotificationCenter.default.addObserver(self, selector: #selector(requestPresentWorldSceneViewController), name: .requestPresentWorldSceneViewController, object: nil)

        PortalEventManager.set()
    }

    func setView() {
        self.skView.ignoresSiblingOrder = true
#if DEBUG
        self.skView.showsFPS = true
        self.skView.showsNodeCount = true
#endif
    }

    func configureTouchManager(scene: SKScene) {
        let recognizers = [
            TapRecognizer(),
        ]

        TouchManager.default.set(scene: scene, recognizers: recognizers)

        TouchManager.default.willSearch = nil
        TouchManager.default.didSearch = nil
    }

    deinit {
        PortalEventManager.free()
    }

    // TODO: check
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

    @objc func requestPresentWorldSceneViewController() {
        let worldViewController = self.storyboard!.instantiateViewController(identifier: "WorldViewController") as! WorldViewController

        self.navigationController!.setViewControllers([worldViewController], animated: false)
    }

}
