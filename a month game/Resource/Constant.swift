//
//  Constant.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/06.
//

import UIKit
import SpriteKit

struct Constant {

    static let defaultWidth = tileWidth
    static let tileTextureWidth: CGFloat = 16.0
    static let tileTextureSize = CGSize(width: tileTextureWidth, height: tileTextureWidth)
    static let tileScale = 6.0
    static let tileWidth = tileTextureWidth * tileScale
    static let tileSize = CGSize(width: tileWidth, height: tileWidth)
    static let margin = defaultWidth / 5.0

    static let defaultNodeSize = CGSize(width: defaultWidth, height: defaultWidth)

    // MARK: - position, size
    static let iPhone5sResolution = CGSize(width: 750, height: 1334)
    static let sceneSize = iPhone5sResolution

    static let sceneCenter = sceneSize.cgPoint / 2.0

    static let screenDownLeft = CGPoint(x: -sceneSize.width / 2.0, y: -sceneSize.height / 2.0)
    static let screenUpRight = CGPoint(x: sceneSize.width / 2.0, y: sceneSize.height / 2.0)

    // MARK: portal scene
    static let enterButtonNodePosition = screenUpRight
    static let enterButtonNodeSize = CGSize(width: defaultWidth * 3, height: defaultWidth)
    static let resetButtonNodePosition = CGPoint(x: screenUpRight.x, y: screenUpRight.y - defaultWidth * 2)
    static let resetButtonNodeSize = CGSize(width: defaultWidth * 2, height: defaultWidth)

    // MARK: misc
    static let menuPosition = (sceneSize - defaultWidth / 2.0 - margin).cgPoint
    static let characterRadius = defaultWidth / 3.0
    static let exitWorldButtonNodeSize = CGSize(width: defaultWidth * 3, height: defaultWidth)

    // MARK: inventory
    static let invWindowPosition = CGPoint(x: sceneCenter.x,
                                           y: defaultWidth / 2.0 + invCellSpacing)
    static let invWindowSize = CGSize(width: sceneSize.width - margin * 2.0, height: defaultWidth)
    static let invCellCount: Int = 5
    static let invCellSpacing: CGFloat = tileTextureWidth

    // MARK: craft pane
    static let craftWindowPosition = CGPoint(x: margin + tileWidth / 2, y: sceneSize.height / 2.0)
    static let craftWindowSize = CGSize(width: invWindowSize.height, height: invWindowSize.width)
    static let craftWindowCellCount = 5

    // MARK: world box
    static let worldSize = tileSize * 512
    static let worldBorder = CGRect(origin: CGPoint(), size: CGSize(width: worldSize.width, height: worldSize.height))
    static let moveableArea = CGRect(origin: CGPoint() + characterRadius, size: worldBorder.size - (characterRadius * 2.0))

    // MARK: - z position
    struct ZPosition {
        // MARK: portal scene
        static let background = -100.0
        static let resetWindow = 100.0

        // MARK: world scene
        static let worldLayer = 0.0
            static let movingLayer = 0.0
                static let tileMap = -100.0
                static let chunkContainer = 0.0
                static let tile = 10.0
                static let gameObject = 20.0
                static let gameObjectCover = 40.0
            static let character = 30.0
        static let fixedLayer = 100.0
            static let ui = 0.0
                static let characterInv = 0.0
                static let craftCell = 0.0
            static let munuWindow = 100.0
    }

    // MARK: - frame
    struct Frame {
        static let character = CGRect(origin: Constant.sceneCenter, size: Constant.defaultNodeSize)
        static let menuButtonNode = CGRect(origin: Constant.menuPosition, size: CGSize(width: Constant.defaultWidth, height: Constant.defaultWidth))
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
    static let tileCountOfChunkSide: Int = 16
    static let tileMapSide: Int = tileCountOfChunkSide * 3
    static let chunkWidth: Double = tileWidth * Double(tileCountOfChunkSide)

    static let velocityDamping = 1000.0
    static let velocityFrictionRatioPerSec = 0.001

    static let sceneScale = 1.0

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
    static let touchBeganEventQueueSize = 10
    static let worldEventQueueSize = 100

    static let accessibleGOColorBlendFactor = 0.5

    static let characterAccessibleRange = 1

//    // MARK: table
//    static let spaceShiftTable: [UInt8] = [
//        6, 7, 0,
//        5, 8, 1,
//        4, 3, 2,
//    ]

//    static let coordVectorTable = [
//        Coordinate(1, 1),
//        Coordinate(1, 0),
//        Coordinate(1, -1),
//        Coordinate(0, -1),
//        Coordinate(-1, -1),
//        Coordinate(-1, 0),
//        Coordinate(-1, 1),
//        Coordinate(0, 1),
//    ]

}
