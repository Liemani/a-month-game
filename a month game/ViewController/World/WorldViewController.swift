//
//  WorldViewController.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/11.
//

import UIKit
import SpriteKit
import GameplayKit

class WorldViewController: UIViewController {

    /// initialize task without relation to view
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        NotificationCenter.default.addObserver(self, selector: #selector(requestPresentPortalSceneViewController), name: .requestPresentPortalSceneViewController, object: nil)
    }

    /// SKView is loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
#if DEBUG
        skView.showsFPS = true
        skView.showsNodeCount = true
#endif

        let worldName = Constant.Name.defaultWorld

        FileUtility.default.setUpEnvironment(worldName: worldName)
        
        if !FileUtility.default.isWorldDirExist(worldName: worldName) {
            Services.set(worldName: worldName)
            WorldGenerator.generate(worldName: Constant.Name.defaultWorld)
        } else {
            Services.set(worldName: worldName)
        }

        MapGenerator.set()

        WorldEventManager.set()
        FrameCycleUpdateManager.set()

        let scene = WorldScene(size: Constant.sceneSize)

        let recognizers: [TouchRecognizer] = [
            TapRecognizer(),
            TapRecognizer(),
            PanRecognizer(scene: scene),
            PinchRecognizer(scene: scene,
                            ui: scene.ui),
            LongTouchRecognizer(),
        ]
        TouchManager.default.set(scene: scene, recognizers: recognizers)

        Logics.set(scene: scene,
                   ui: scene.ui,
                   invInv: scene.invContainer.invInv,
                   fieldInv: scene.invContainer.fieldInv,
                   infoWindow: scene.infoWindow,
                   world: scene.worldLayer,
                   character: scene.character,
                   chunkContainer: scene.chunkContainer,
                   invContainer: scene.invContainer,
                   accessibleGOTracker: scene.accessibleGOTracker)

        Particle.setUp()

        skView.presentScene(scene)
    }

    deinit {
        Services.free()
        MapGenerator.free()
        WorldEventManager.free()
        FrameCycleUpdateManager.free()

        Logics.free()

        Particle.free()

    }

    // MARK: - transition
    @objc func requestPresentPortalSceneViewController() {
        let portalSceneViewController = storyboard!.instantiateViewController(identifier: "PortalSceneViewController") as! PortalViewController

        self.navigationController!.setViewControllers([portalSceneViewController], animated: false)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]

//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .all
    }

    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key else { return }

        var direction: Direction4

        switch key.keyCode {
        case .keyboardW:
            direction = .north
        case .keyboardA:
            direction = .west
        case .keyboardS:
            direction = .south
        case .keyboardD:
            direction = .east
        default:
            return
        }

        Logics.default.character.jumpChunk(direction: direction)
    }

}
