//
//  Constant.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/06.
//

import UIKit
import SpriteKit

struct Constant {

    static let defaultSize = tileSide
    static let tileTextureSide = 16.0
    static let tileTextureSize = CGSize(width: tileTextureSide, height: tileTextureSide)
    static let tileScale = 6.0
    static let tileSide = tileTextureSide * tileScale
    static let tileSize = CGSize(width: tileSide, height: tileSide)
    static let margin = defaultSize / 5.0

    static let defaultNodeSize = CGSize(width: defaultSize, height: defaultSize)

    // MARK: - position, size
    static let iPhone5sResolution = CGSize(width: 750, height: 1334)
    static let sceneSize = iPhone5sResolution

    static let sceneCenter = sceneSize.toCGPoint() / 2.0

    static let screenDownLeft = CGPoint(x: -sceneSize.width / 2.0, y: -sceneSize.height / 2.0)
    static let screenUpRight = CGPoint(x: sceneSize.width / 2.0, y: sceneSize.height / 2.0)

    // MARK: portal scene
    static let enterButtonNodePosition = screenUpRight
    static let enterButtonNodeSize = CGSize(width: defaultSize * 3, height: defaultSize)
    static let resetButtonNodePosition = CGPoint(x: screenUpRight.x, y: screenUpRight.y - defaultSize * 2)
    static let resetButtonNodeSize = CGSize(width: defaultSize * 2, height: defaultSize)

    // MARK: tile map
    static let tileMapSide = tileSide * Double(gridSize)
    static let tileMapPosition = CGPoint() + (tileMapSide / 2.0)

    // MARK: misc
    static let menuPosition = (sceneSize - defaultSize / 2.0 - margin).toCGPoint()
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
    static let worldBorder = CGRect(origin: CGPoint(), size: CGSize(width: tileMapSide, height: tileMapSide))
    static let moveableArea = CGRect(origin: CGPoint() + characterRadius, size: worldBorder.size - (characterRadius * 2.0))

    // MARK: - z position
    struct ZPosition {
        static let background = -500.0
        static let resetWindow = 500.0

        static let movingLayer = -500.0
        static let tileMap = -100.0
        static let gameObjectLayer = 0.0
        static let gameObjectNode = 10.0
        static let tileNode = 0.0

        static let fixedLayer = 0.0
        static let ui = 0.0
        static let thirdHand = 100.0
        static let munuWindow = 500.0

        static let inventoryCell = 1.0
        static let inventoryCellHand = 2.0
        static let craftCell = 1.0
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
    static let gridSize: Int = 256

    static let velocityDamping = 1000.0
    static let velocityFrictionRatioPerSec = 0.001

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

    // MARK: map position
    static let centerTileIndex = gridSize / 2

}
