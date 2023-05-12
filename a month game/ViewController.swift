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

    var fileController: FileController!

    var portalController: PortalSceneController?
    var worldController: WorldSceneController?

    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
        setPortalScene()

//        setGestureRecognizer()
    }

//    func setGestureRecognizer() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
//        tapGesture.delegate = self
//        self.view.addGestureRecognizer(tapGesture)
//
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//        panGesture.delegate = self
//        self.view.addGestureRecognizer(panGesture)
//    }
//
//    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
//        // Handle the tap gesture here
//        let location = sender.location(in: self.view)
//        print("Tap detected at (\(location.x), \(location.y))")
//    }
//
//    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
//        // Handle the tap gesture here
//        let location = sender.location(in: self.view)
//        print("Pan detected at (\(location.x), \(location.y))")
//    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
//                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }

    func setView() {
        let view = self.view as! SKView
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
    }

    func setPortalScene() {
        worldController = nil
        let portalController = PortalSceneController()
        portalController.viewController = self
        let view = self.view as! SKView
        view.presentScene(portalController.portalScene)
        self.portalController = portalController
    }

    func setWorldScene() {
        portalController = nil
        let worldController = WorldSceneController(viewController: self, worldName: Constant.defaultWorldName)
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
