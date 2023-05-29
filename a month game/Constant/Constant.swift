//
//  Constant.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/06.
//

import UIKit
import SpriteKit

struct Constant {

    static let defaultSize = 250.0
    static let tileSide = defaultSize
    static let margin = defaultSize / 5.0

    static let defaultNodeSize = CGSize(width: defaultSize, height: defaultSize)

    // MARK: - position, size
    static let iPhone5sResolution = CGSize(width: 750, height: 1334)
    static let sceneSize = iPhone5sResolution * 2.0

    static let sceneCenter = iPhone5sResolution.toCGPoint()

    static let screenDownLeft = CGPoint(x: -sceneSize.width / 2, y: -sceneSize.height / 2)
    static let screenUpRight = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)

    // MARK: portal scene
    static let enterButtonPosition = screenUpRight
    static let enterButtonSize = CGSize(width: defaultSize * 3, height: defaultSize)
    static let resetButtonPosition = CGPoint(x: screenUpRight.x, y: screenUpRight.y - defaultSize * 2)
    static let resetButtonSize = CGSize(width: defaultSize * 2, height: defaultSize)

    // MARK: tile map
    static let tileMapSide = tileSide * Double(gridSize)
    static let tileMapPosition = CGPoint() + (tileMapSide / 2.0)

    // MARK: misc
    static let menuPosition = (sceneSize - defaultSize / 2.0 - margin).toCGPoint()
    static let characterRadius = defaultSize / 3.0
    static let exitWorldButtonSize = CGSize(width: defaultSize * 3, height: defaultSize)

    // MARK: inventory
    static let inventoryPanePosition = CGPoint() + margin
    static let inventoryPaneSize = CGSize(width: sceneSize.width - margin * 2.0, height: defaultSize)
    static let inventoryCellCount = 5

    // MARK: craft pane
    static let craftPanePosition = CGPoint(x: margin, y: (sceneSize.height - inventoryPaneSize.width) / 2.0)
    static let craftPaneSize = CGSize(width: inventoryPaneSize.height, height: inventoryPaneSize.width)
    static let craftPaneCellCount = 5

    // MARK: world box
    static let worldBorder = CGRect(origin: CGPoint(), size: CGSize(width: tileMapSide, height: tileMapSide))
    static let moveableArea = CGRect(origin: CGPoint() + characterRadius, size: worldBorder.size - (characterRadius * 2.0))

    // MARK: - z position
    struct ZPosition {
        static let movingLayer = -500.0
        static let tileMap = -100.0
        static let gameObjectLayer = 0.0
        static let gameObject = 10.0

        static let fixedLayer = 0.0
        static let ui = 0.0
        static let thirdHand = 100.0
        static let menuWindow = 500.0

        static let inventoryCell = 1.0
        static let inventoryCellHand = 2.0
        static let craftCell = 1.0
    }

    // MARK: - frame
    struct Frame {
        static let character = CGRect(origin: Constant.sceneCenter, size: Constant.defaultNodeSize)
        static let menuButton = CGRect(origin: Constant.menuPosition, size: CGSize(width: Constant.defaultSize, height: Constant.defaultSize))
        static let enterButton = CGRect(origin: Constant.enterButtonPosition, size: Constant.enterButtonSize)
        static let resetButton = CGRect(origin: Constant.resetButtonPosition, size: Constant.resetButtonSize)
        static let exitWorldButton = CGRect(origin: Constant.sceneCenter, size: Constant.exitWorldButtonSize)
    }

    // MARK: - data
    static let defaultWorldName = "world000"
    static let tileMapFileName = "tileMap.dat"
    static let dataModelFileName = "DataModel.sqlite"
    static let worldDataModelName = "DataModel"
    static let gameObjectDataEntityName = "GameObjectMO"

    // MARK: - recipe
    static let recipes: [GameObjectType: [(type: GameObjectType, count: Int)]] = [
        .woodWall: [(.branch, 4)],
        .axe: [(.stone, 1), (.branch, 1)],
    ]

    // MARK: - UserDefaults key
    static let idGeneratorKey = "idGenerator"

    // MARK: - etc
    static let gridSize: Int = 100

    static let velocityDamping = 1000.0
    static let velocityFrictionRatioPerSec = 0.001

    struct ResourceName {
        static let character = "character"
        static let menuButton = "menu button"
        static let inventoryCell = "inventory_cell"
        static let craftCell = "craft_cell"
        static let bgPortal = "bg_portal"
        static let button = "button"
        static let leftHand = "left_hand"
        static let rightHand = "right_hand"
    }

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
