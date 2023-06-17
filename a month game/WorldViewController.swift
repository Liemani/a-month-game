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

    var worldScene: WorldScene {
        let skView = self.view as! SKView
        return skView.scene! as! WorldScene
    }

    // MARK: model
    var gameObjectsModel: GameObjectsModel!
    var characterModel: CharacterModel!
    var tileMapModel: TileMapModel!

    /// initialize task without relation to view
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        NotificationCenter.default.addObserver(self, selector: #selector(requestPresentPortalViewController), name: .requestPresentPortalViewController, object: nil)
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

        let scene = WorldScene(size: Constant.sceneSize)
        skView.presentScene(scene)
    }

    /// set up from disk
    func setUp(serviceContainer: WorldServiceContainer) {
        self.setUpModel(serviceContainer: serviceContainer)
        self.setUpScene()

#if DEBUG
        self.debugCode()
#endif
    }

    func setUpModel(serviceContainer: WorldServiceContainer) {
        self.gameObjectsModel = GameObjectsModel(serviceContainer: serviceContainer)
        self.characterModel = CharacterModel(service: serviceContainer.worldDataService)
        self.tileMapModel = TileMapModel(tileService: serviceContainer.tileService)
    }

    func setUpScene() {
        self.worldScene.setUp(characterPosition: self.characterModel.position)
        self.setUpTile()
        self.setUpGOMOs()
    }

    func setUpTile() {
        let tileMapData = self.tileMapModel.tilesMap()
        let tileMap = tileMapData.withUnsafeBytes { $0.bindMemory(to: Int.self) }
        for x in 0..<Constant.gridSize {
            for y in 0..<Constant.gridSize {
                let rawValue = tileMap[x + y * Constant.gridSize]
                let tileType = TileType(rawValue: rawValue) ?? TileType(rawValue: 0)!
                self.set(tileType: tileType, toX: x, y: y)
            }
        }
    }

    func setUpGOMOs() {
        let goMOs = self.gameObjectsModel.loadGOMOs()
        for goMO in goMOs {
            self.addGO(from: goMO)
        }
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

    // MARK: - edit model
    // MARK: - game object
    /// Called when loading GOMO from disk
    private func addGO(from goMO: GameObjectMO) {
        guard let containerType = goMO.containerType else { return }

        let container = self.worldScene.containers[containerType]!
        let goMOCoord = goMO.coord

        if container.isValid(goMOCoord)
            , let go = GameObject.new(from: goMO) {
            container.addGO(go, to: goMOCoord)
            self.worldScene.interactionZone.reserveUpdate()
            self.gameObjectsModel.goMOGO[goMO] = go
        }
    }

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
    func addGOMO(of goType: GameObjectType, to goCoord: GameObjectCoordinate) {
        let go = self.worldScene.addGO(of: goType, to: goCoord)
        let goMO = self.gameObjectsModel.newGOMO(of: goType, to: goCoord)
        self.gameObjectsModel.goMOGO[goMO] = go
    }

    /// Add GOMO and move GO
    /// Called when craft, so don't need to update
    func addGOMO(from go: GameObject, to goCoord: GameObjectCoordinate) {
        self.worldScene.containers[goCoord.containerType]!.moveGO(go, to: goCoord.coord)
        let goMO = self.gameObjectsModel.newGOMO(of: go.type, to: goCoord)
        self.gameObjectsModel.goMOGO[goMO] = go
    }

    func moveGOMO(from go: GameObject, to goCoord: GameObjectCoordinate) {
        let goMO = self.gameObjectsModel.goMOGO[go]!
        self.gameObjectsModel.setGOMO(goMO, to: goCoord)
        self.worldScene.containers[goCoord.containerType]!.moveGO(go, to: goCoord.coord)
        self.worldScene.interactionZone.reserveUpdate()
    }

    func removeGOMO(from go: GameObject) {
        let goMO = self.gameObjectsModel.goMOGO.remove(go)!
        self.gameObjectsModel.remove(goMO)
        go.removeFromParent()
        self.worldScene.interactionZone.reserveUpdate()
    }

    // TODO: check this method, other edit is perfect
    func removeGOMO(from gos: any Sequence<GameObject>) {
        for go in gos {
            let go = go as! GameObject
            let goMO = self.gameObjectsModel.goMOGO.remove(go)!
            self.gameObjectsModel.remove(goMO)
            go.removeFromParent()
        }
        self.worldScene.interactionZone.reserveUpdate()
    }

    // MARK: - tile
    func set(tileType: TileType, toX x: Int, y: Int) {
        self.worldScene.tileMap.setTileGroup(tileType.tileGroup, andTileDefinition: tileType.tileDefinition, forColumn: y, row: x)
    }

    // MARK: - transition
    @objc
    func requestPresentPortalViewController() {
        let portalViewController = storyboard?.instantiateViewController(identifier: "PortalViewController") as! PortalViewController
        self.navigationController?.setViewControllers([portalViewController], animated: false)
    }

    func update() {
        self.gameObjectsModel.contextSaveIfNeed()
    }

#if DEBUG
    private func debugCode() {
        for goMO in self.gameObjectsModel.goMOGO.goMOs {
            print("id: \(goMO.id), typeID: \(goMO.typeID), containerID: \(goMO.containerID), coordinate: (\(goMO.chunkX), \(goMO.chunkY), \(UInt16(bitPattern: goMO.chunkLocation)))")
        }
    }
#endif

}
