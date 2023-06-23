//
//  Constant.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/06.
//

import UIKit
import SpriteKit

struct Constant {

    static let defaultSize = tileWidth
    static let tileTextureWidth = 16.0
    static let tileTextureSize = CGSize(width: tileTextureWidth, height: tileTextureWidth)
    static let tileScale = 6.0
    static let tileWidth = tileTextureWidth * tileScale
    static let tileSize = CGSize(width: tileWidth, height: tileWidth)
    static let margin = defaultSize / 5.0

    static let defaultNodeSize = CGSize(width: defaultSize, height: defaultSize)

    // MARK: - position, size
    static let iPhone5sResolution = CGSize(width: 750, height: 1334)
    static let sceneSize = iPhone5sResolution

    static let sceneCenter = sceneSize.cgPoint / 2.0

    static let screenDownLeft = CGPoint(x: -sceneSize.width / 2.0, y: -sceneSize.height / 2.0)
    static let screenUpRight = CGPoint(x: sceneSize.width / 2.0, y: sceneSize.height / 2.0)

    // MARK: portal scene
    static let enterButtonNodePosition = screenUpRight
    static let enterButtonNodeSize = CGSize(width: defaultSize * 3, height: defaultSize)
    static let resetButtonNodePosition = CGPoint(x: screenUpRight.x, y: screenUpRight.y - defaultSize * 2)
    static let resetButtonNodeSize = CGSize(width: defaultSize * 2, height: defaultSize)

    // MARK: misc
    static let menuPosition = (sceneSize - defaultSize / 2.0 - margin).cgPoint
    static let characterRadius = defaultSize / 3.0
    static let exitWorldButtonNodeSize = CGSize(width: defaultSize * 3, height: defaultSize)

    // MARK: inventory
    static let invWindowPosition = CGPoint() + margin
    static let invWindowSize = CGSize(width: sceneSize.width - margin * 2.0, height: defaultSize)
    static let inventoryCellCount = 5

    // MARK: craft pane
    static let craftWindowPosition = CGPoint(x: margin, y: (sceneSize.height - invWindowSize.width) / 2.0)
    static let craftWindowSize = CGSize(width: invWindowSize.height, height: invWindowSize.width)
    static let craftWindowCellCount = 5

    // MARK: world box
    static let worldSize = tileSize * 512
    static let worldBorder = CGRect(origin: CGPoint(), size: CGSize(width: worldSize.width, height: worldSize.height))
    static let moveableArea = CGRect(origin: CGPoint() + characterRadius, size: worldBorder.size - (characterRadius * 2.0))

    // MARK: - z position
    struct ZPosition {
        // MARK: portal scene
        static let background = -500.0
        static let resetWindow = 500.0

        // MARK: world scene
        static let worldLayer = 0.0
            static let movingLayer = 0.0
                static let tileMap = -500.0
                static let chunkContainer = 0.0
                static let tile = -10.0
                static let gameObject = 0.0
                static let gameObjectCover = 20.0
            static let character = 10.0

        // TODO: reset value
        static let fixedLayer = 0.0
            static let ui = 100.0
            static let inventoryCell = 1.0
            static let inventoryCellHand = 2.0
            static let craftCell = 1.0
            static let munuWindow = 500.0
    }

    // MARK: - frame
    struct Frame {
        static let character = CGRect(origin: Constant.sceneCenter, size: Constant.defaultNodeSize)
        static let menuButtonNode = CGRect(origin: Constant.menuPosition, size: CGSize(width: Constant.defaultSize, height: Constant.defaultSize))
        static let enterButtonNode = CGRect(origin: Constant.enterButtonNodePosition, size: Constant.enterButtonNodeSize)
        static let resetButtonNode = CGRect(origin: Constant.resetButtonNodePosition, size: Constant.resetButtonNodeSize)
        static let exitWorldButtonNode = CGRect(origin: Constant.sceneCenter, size: Constant.exitWorldButtonNodeSize)
        static let yesButtonNode = CGRect(origin: Constant.Frame.enterButtonNode.origin, size: Constant.Frame.resetButtonNode.size)
        static let noButtonNode = Constant.Frame.resetButtonNode
    }

    struct Name {
        static let defaultWorld = "world000"

        // MARK: file name
        static let tileMapFile = "tileMap.dat"
        static let worldDataModelFile = "worldDataModel.sqlite"
        static let worldDataFile = "worldData.dat"

        // MARK: data model name
        static let worldDataModel = "WorldDataModel"
        static let gameObjectEntity = "GameObjectMO"
        static let chunkCoordinateEntity = "ChunkCoordinateMO"
        static let invCoordinateEntity = "InventoryCoordinateMO"
    }

    // MARK: - recipe
    static let recipes: [GameObjectType: [(type: GameObjectType, count: Int)]] = [
        .woodWall: [(.woodStick, 4)],
        .axe: [(.stone, 1), (.woodStick, 1)],
    ]

    // MARK: - UserDefaults key
    static let idGeneratorKey = "idGenerator"

    // MARK: - etc
    static let tileCountInChunkSide: Int = 16
    static let tileMapSide: Int = tileCountInChunkSide * 3
    static let chunkWidth: Double = tileWidth * Double(tileCountInChunkSide)

    static let velocityDamping = 1000.0
    static let velocityFrictionRatioPerSec = 0.001

    static let sceneScale = 0.1

    struct ResourceName {
        static let menuButtonNode = "menu button"
        static let inventoryCell = "inventory_cell"
        static let craftCell = "craft_cell"
        static let bgPortal = "bg_portal"
        static let button = "button"
        static let leftHand = "left_hand"
        static let rightHand = "right_hand"
    }

    static let initialNextID = 1
    static let touchEventQueueSize = 10
    static let sceneEventQueueSize = 100

    static let accessableGOColorBlendFactor = 0.5

    // MARK: table
    static let spaceShiftTable: [UInt8] = [
        6, 7, 0,
        5, 8, 1,
        4, 3, 2,
    ]

    static let coordVectorTable = [
        Coordinate(1, 1),
        Coordinate(1, 0),
        Coordinate(1, -1),
        Coordinate(0, -1),
        Coordinate(-1, -1),
        Coordinate(-1, 0),
        Coordinate(-1, 1),
        Coordinate(0, 1),
    ]

}
