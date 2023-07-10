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
        
        WorldGenerator.generate(worldName: Constant.Name.defaultWorld)

        Services.set(worldName: Constant.Name.defaultWorld)
        WorldEventManager.set()
        FrameCycleUpdateManager.set()

        let scene = WorldScene(size: Constant.sceneSize)

        TouchRecognizerManager.set(scene: scene,
                                   ui: scene.ui,
                                   character: scene.character)

        Logics.set(scene: scene,
                   ui: scene.ui,
                   invInv: scene.invContainer.invInv,
                   fieldInv: scene.invContainer.fieldInv,
                   infoWindow: scene.infowindow,
                   character: scene.character,
                   chunkContainer: scene.chunkContainer,
                   invContainer: scene.invContainer,
                   accessibleGOTracker: scene.accessibleGOTracker)

        Particle.setUp()

        skView.presentScene(scene)
    }

    deinit {
        Services.free()
        WorldEventManager.free()
        FrameCycleUpdateManager.free()

        TouchRecognizerManager.free()
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

}

    // TODO: check this method, other edit is perfect
//    func remove(from gos: any Sequence<GameObject>) {
//        print("ingredient of craft should removed")
//        //        for go in gos {
//        //            let go = go as! GameObjectNode
//        //            let goMO = self.gameObjectModel.goMOGO.remove(go)!
//        //            self.gameObjectModel.remove(goMO)
//        //            go.removeFromParent()
//        //        }
//        //        self.worldScene.interactionZone.reserveUpdate()
//    }

// MARK: - edit model
    // MARK: - game object
    /// Called when loading GOMO from disk
    //    private func addGO(from goMO: GameObjectMO) {
    //        guard let containerType = goMO.containerType else { return }
    //
    //        let container = self.worldScene.containers[containerType]!
    //        let goMOCoord = goMO.coord
    //
    //        if container.isValid(goMOCoord)
    //            , let go = GameObjectNode.new(from: goMO) {
    //            container.addGO(go, to: goMOCoord)
    //            self.worldScene.interactionZone.reserveUpdate()
    //            self.gameObjectModel.goMOGO[goMO] = go
    //        }
    //    }

    /* TODO: renewal gomogo model
     isValid 를 여기서 호출하야 하나?
     valid 체크를 해야하나?

     로드한 데이터를 사용해 모델을 만든다
     모델을 바탕으로 화면을 그린다
     이 때 매 프레임 모델을 읽어서 화면을 그리도록 할 수 있으나
     이는 성능상 너무 비효율적이다
     따라서 모델에 변동 사항이 있는 경우에만 모델을 읽어서 화면을 그리도록 한다

     그럼 내가 해야 할 일은 화면을 그릴 모델을 필요한 만큼만 갖도록 유지하는 것이다
     그리고 그렇게 지니고 있는 모델을 변동이 있는 경우에만 화면에 새로 그리는 것이다
     */

    // MARK: - game object managed object
    //    func addGOMO(of goType: GameObjectType, to goCoord: GameObjectCoordinate) {
    //        let go = self.worldScene.addGO(of: goType, to: goCoord)
    //        let goMO = self.gameObjectModel.newGOMO(of: goType, to: goCoord)
    //        self.gameObjectModel.goMOGO[goMO] = go
    //    }
    //
    //    /// Add GOMO and move GO
    //    /// Called when craft, so don't need to update
    //    func addGOMO(from go: GameObjectNode, to goCoord: GameObjectCoordinate) {
    //        self.worldScene.containers[goCoord.containerType]!.moveGO(go, to: goCoord.coord)
    //        let goMO = self.gameObjectModel.newGOMO(of: go.type, to: goCoord)
    //        self.gameObjectModel.goMOGO[goMO] = go
    //    }
    //
    //    func moveGOMO(from go: GameObjectNode, to goCoord: GameObjectCoordinate) {
    //        let goMO = self.gameObjectModel.goMOGO[go]!
    //        self.gameObjectModel.setGOMO(goMO, to: goCoord)
    //        self.worldScene.containers[goCoord.containerType]!.moveGO(go, to: goCoord.coord)
    //        self.worldScene.interactionZone.reserveUpdate()
    //    }
    //
    //    func removeGOMO(from go: GameObjectNode) {
    //        let goMO = self.gameObjectModel.goMOGO.remove(go)!
    //        self.gameObjectModel.remove(goMO)
    //        go.removeFromParent()
    //        self.worldScene.interactionZone.reserveUpdate()
    //    }


