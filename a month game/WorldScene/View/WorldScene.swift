//
//  WorldScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/03.
//

import SpriteKit
import GameplayKit

class WorldScene: SKScene {

    weak var worldSceneController: WorldSceneController!

    var tileMap: SKTileMapNode!
    var gameObjectField: SKNode!

    var ui: SKNode!
    var menuButton: SKNode!

    var menuWindow: SKNode!
    var exitWorldButton: SKNode!

    var isMenuOpen: Bool {
        return !menuWindow.isHidden
    }

    var accessBound: CGRect {
        return CGRect(origin: self.camera!.position, size: Constant.defaultNodeSize * 2.0)
    }

    // MARK: - set up
    func setUp(worldSceneController: WorldSceneController) {
        self.worldSceneController = worldSceneController

        self.size = Constant.screenSize
        self.scaleMode = .aspectFit

        debugCode()

        addMovingLayer(to: self)
        addCamera(to: self)
    }

    func debugCode() {
        let origin = SKSpriteNode(imageNamed: Resource.Name.character)
        self.addChild(origin)
    }

    // MARK: add moving layer
    func addMovingLayer(to parent: SKNode) {
        let movingLayer = SKNode()

        movingLayer.zPosition = Constant.ZPosition.movingLayer

        parent.addChild(movingLayer)

        addBackground(to: movingLayer)
        addGameObjectField(to: movingLayer)
    }

    func addBackground(to parent: SKNode) {
        let background = SKNode()

        background.zPosition = Constant.ZPosition.background

        parent.addChild(background)

        addTileMapNode(to: background)
    }

    func addTileMapNode(to parent: SKNode) {
        let tileGroups = Resource.tileTypeToResource.map { $0.tileGroup }
        let tileSet = SKTileSet(tileGroups: tileGroups)

        let tileMap = SKTileMapNode(tileSet: tileSet, columns: Constant.gridSize, rows: Constant.gridSize, tileSize: Constant.defaultNodeSize)

        tileMap.position = Constant.tileMapNodePosition

        parent.addChild(tileMap)
        self.tileMap = tileMap
    }

    func addGameObjectField(to parent: SKNode) {
        let gameObjectField = SKNode()

        gameObjectField.zPosition = Constant.ZPosition.gameObjectField

        parent.addChild(gameObjectField)
        self.gameObjectField = gameObjectField
    }

    // MARK: add camera
    func addCamera(to parent: SKNode) {
        let camera = SKCameraNode()

        camera.position = Constant.tileMapNodePosition

        parent.addChild(camera)
        self.camera = camera

        addUI(to: camera)
        addMenuWindow(to: camera)
    }

    func addUI(to parent: SKNode) {
        let ui = SKNode()

        ui.zPosition = Constant.ZPosition.ui

        parent.addChild(ui)
        self.ui = ui

        let character: SKSpriteNode = SKSpriteNode(imageNamed: Resource.Name.character)

        character.position = Constant.Frame.character.origin
        character.size = Constant.Frame.character.size

        ui.addChild(character)

        let menuButton: SKSpriteNode = SKSpriteNode(imageNamed: Resource.Name.menuButton)

        menuButton.position = Constant.Frame.menuButton.origin
        menuButton.size = Constant.Frame.menuButton.size

        ui.addChild(menuButton)
        self.menuButton = menuButton

        let inventoryCellPositionGap: CGFloat = (Constant.inventoryCellLastPosition.x - Constant.inventoryCellFirstPosition.x) / CGFloat(Constant.inventoryCellCount - 1)

        let inventoryCellTexture = SKTexture(imageNamed: Resource.Name.inventoryCell)
        for index in 0..<Constant.inventoryCellCount {
            let inventoryCellNode = SKSpriteNode(texture: inventoryCellTexture)

            inventoryCellNode.position = CGPoint(x: Constant.inventoryCellFirstPosition.x + inventoryCellPositionGap * CGFloat(index), y: Constant.inventoryCellFirstPosition.y)
            inventoryCellNode.size = Constant.defaultNodeSize

            ui.addChild(inventoryCellNode)
        }
    }

    func addMenuWindow(to parent: SKNode) {
        let menuWindow = SKShapeNode()

        menuWindow.zPosition = Constant.ZPosition.menu
        menuWindow.isHidden = true

        parent.addChild(menuWindow)
        self.menuWindow = menuWindow

        let background = SKShapeNode()

        let rect = CGRect(origin: Constant.screenDownLeft, size: Constant.screenSize)
        let path = CGPath(rect: rect, transform: nil)
        background.path = path
        background.fillColor = .black
        background.alpha = 0.5
        background.zPosition = -1.0

        menuWindow.addChild(background)

        let buttonTexture = SKTexture(imageNamed: Resource.Name.button)
        let exitWorldButton = Helper.createLabeledSpriteNode(texture: buttonTexture, in: Constant.Frame.exitWorldButton, labelText: "Exit World", andAddTo: menuWindow)
        self.exitWorldButton = exitWorldButton
    }


    // MARK: - touoch
    var menuButtonTouch: UITouch? = nil

    var moveTouch: UITouch? = nil
    var previousMoveTouchTimestamp1: TimeInterval!
    var previousMoveTouchTimestamp2: TimeInterval!
    var previousMoveTouchLocation2: CGPoint!
    var velocityVector = CGVector(dx: 0.0, dy: 0.0)

    func touchDown(touch: UITouch) {
        if self.isMenuOpen {
            return
        }

        if touch.is(onThe: self.menuButton) {
            self.menuButton.alpha = 0.5
            menuButtonTouch = touch
        } else if let gameObject = self.gameObjectField.child(at: touch) {
            print("start touch game object node")
        } else {
            moveTouch = touch
            previousMoveTouchTimestamp1 = touch.timestamp
        }
    }

    private func startDragging(touch: UITouch) {
    }

//    private func addGameObjectAtTouchLocation(touch: UITouch) {
//        let scene = self.scene as! WorldScene
//        let location = touch.location(in: scene)
//        let x = Int(location.x) / Int(Constant.defaultSize)
//        let y = Int(location.y) / Int(Constant.defaultSize)
//
//        let coordinate = GameObjectCoordinate(inventory: 0, x: x, y: y)
//        let typeID = Int(arc4random_uniform(3) + 1)
//
//        let gameObject = GameObject.new(ofTypeID: typeID, id: nil, coordinate: coordinate)
//
//        self.worldSceneController.add(gameObject)
//    }

    func touchMoved(touch: UITouch) {
        if self.isMenuOpen {
            return
        }

        if touch == self.menuButtonTouch {
            self.menuButton.alpha = touch.is(onThe: self.menuButton) ? 0.5 : 1.0
        } else if touch == self.moveTouch {
            self.moveCamera(touch: touch)
            self.previousMoveTouchTimestamp2 = self.previousMoveTouchTimestamp1
            self.previousMoveTouchTimestamp1 = touch.timestamp
            self.previousMoveTouchLocation2 = touch.previousLocation(in: self.camera!)
        } else {
            print("no matching touch")
        }
    }

    func touchUp(touch: UITouch) {
        if self.isMenuOpen {
            let currentLocation = touch.location(in: self.camera!)
            if self.exitWorldButton.contains(currentLocation) {
                performSegueToPortalScene()
            } else {
                self.menuWindow.isHidden = true
            }

            return
        }

        if touch == self.menuButtonTouch {
            if touch.is(onThe: self.menuButton) {
                self.menuWindow.isHidden = false
                self.moveTouch = nil
            }
            self.menuButton.alpha = 1.0
            self.menuButtonTouch = nil
        } else if touch == self.moveTouch {
            setVelocityVector()
        }
    }

    func setVelocityVector() {
        let previousLocation1 = self.moveTouch!.previousLocation(in: self.camera!)
        let previousLocation2 = self.previousMoveTouchLocation2!
        let timeInterval = self.previousMoveTouchTimestamp1 - self.previousMoveTouchTimestamp2

        self.velocityVector = -(previousLocation1 - previousLocation2) / timeInterval
    }

    private func performSegueToPortalScene() {
        self.worldSceneController.viewController.setPortalScene()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchDown(touch: touch) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchMoved(touch: touch) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchUp(touch: touch) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchUp(touch: touch) }
    }

    // MARK: - update scene
    var lastUpdateTime: TimeInterval = 0.0
    override func update(_ currentTime: TimeInterval) {
        let timeInterval: TimeInterval = currentTime - lastUpdateTime

        updateCamera(timeInterval: timeInterval)
        updateVelocity(timeInterval: timeInterval)

        lastUpdateTime = currentTime
    }

    func updateCamera(timeInterval: TimeInterval) {
        self.camera!.position += self.velocityVector * timeInterval
    }

    func updateVelocity(timeInterval: TimeInterval) {
        let velocity = self.velocityVector.magnitude
        self.velocityVector =
            velocity <= Constant.velocityDamping
            ? CGVectorMake(0.0, 0.0)
            : self.velocityVector * pow(Constant.velocityFrictionRatioPerSec, timeInterval)
    }

    // MARK: - edit
    func set(tileType: Int, toX x: Int, y: Int) {
        let resourceIndex = Resource.tileTypeToResource.indices.contains(tileType) ? tileType : 0
        let tileInformation = Resource.tileTypeToResource[resourceIndex]

        self.tileMap.setTileGroup(tileInformation.tileGroup, andTileDefinition: tileInformation.1, forColumn: y, row: x)
    }

    func add(_ gameObject: GameObject) -> SKSpriteNode {
        let texture = Resource.getTexture(of: gameObject)
        let node = SKSpriteNode(texture: texture)

        node.position = (gameObject.coordinate.cgPoint() + 0.5) * Constant.defaultSize

        self.gameObjectField.addChild(node)

        return node
    }

    // MARK: - etc
    private func moveCamera(touch: UITouch) {
        let currentLocation = touch.location(in: self.camera!)
        let previousLocation = touch.previousLocation(in: self.camera!)

        let difference = currentLocation - previousLocation
        self.camera!.position -= difference
    }

}
