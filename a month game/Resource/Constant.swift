//
//  Constant.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/06.
//

import UIKit
import SpriteKit

struct Constant {

    static let tileTextureWidth = 64.0
    static let tileTextureSize = CGSize(width: tileTextureWidth, height: tileTextureWidth)

    static let tileScale = 1.5
    static let tileWidth = tileTextureWidth * tileScale

    static let defaultWidth = tileWidth

    static let defaultNodeSize = CGSize(width: defaultWidth, height: defaultWidth)
    static let tileSize = defaultNodeSize

    static let defaultPadding: CGFloat = 16.0

    static let gameObjectSize = defaultNodeSize * 0.9
    static let coverSize = defaultNodeSize * 0.9

    static let margin = defaultWidth / 2.0

    // MARK: - position, size
    static let iPhone5sResolution = CGSize(width: 750, height: 1334)
    static let sceneSize = iPhone5sResolution

    static let sceneCenter = sceneSize.cgPoint / 2.0

    static let worldLayer = sceneCenter

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
                                           y: defaultWidth / 2.0 + defaultPadding)
    static let invWindowSize = CGSize(width: sceneSize.width - margin * 2.0, height: defaultWidth)
    static let invCellCount: Int = 5

    // MARK: craft pane
    static let craftWindowPosition = CGPoint(x: tileWidth / 2 + defaultPadding, y: sceneSize.height / 2.0)
    static let craftWindowSize = CGSize(width: invWindowSize.height, height: invWindowSize.width)
    static let craftWindowCellCount = 5

    // MARK: world box
    static let worldSize = tileSize * 512
    static let worldBorder = CGRect(origin: CGPoint(), size: CGSize(width: worldSize.width, height: worldSize.height))
    static let moveableArea = CGRect(origin: CGPoint() + characterRadius, size: worldBorder.size - (characterRadius * 2.0))

    // MARK: - size
    struct Size {
        static let particle = CGSize(width: 10.0, height: 10.0)
        static let qualityBox = CGSize(width: 35.0, height: 15.0)
        static let infoWindow = CGSize(width: Constant.defaultWidth * 3.0,
                                       height: Constant.defaultWidth * 5.0)
    }

    // MARK: - position
    struct Position {
        static let qualityBox = CGPoint(x: 20.0, y: 30.0)
        static let qualityLabel = CGPoint(x: Size.qualityBox.width / 2.0,
                                          y: -Size.qualityBox.height / 2.0)
    }

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
                        static let gameObjectQualityLabel = 30.0
                        static let gameObjectCover = 20.0
                static let fieldInv = 50.0
            static let character = 30.0
                static let particle = 20.0
        static let ui = 100.0
            static let characterInv = 0.0
            static let craftCell = 0.0
            static let infoWindow = 50.0
            static let menuWindow = 100.0
    }

    // MARK: - frame
    struct Frame {
        static let enterButton = CGRect(
            origin: enterButtonNodePosition,
            size: enterButtonNodeSize)
        static let resetButton = CGRect(
            origin: resetButtonNodePosition,
            size: resetButtonNodeSize)
        static let discordButton = CGRect(
            origin: menuPosition,
            size: defaultNodeSize)
        static let yesButton = CGRect(
            origin: enterButton.origin,
            size: resetButton.size)
        static let noButton = CGRect(
            origin: resetButtonNodePosition,
            size: resetButtonNodeSize)
        static let character = CGRect(
            origin: sceneCenter,
            size: defaultNodeSize)
        static let menuButton = CGRect(
            origin: menuPosition,
            size: defaultNodeSize)
        static let infoWindowCloseButton = CGRect(
            origin: Size.infoWindow.cgPoint / 2.0 - defaultPadding,
            size: CGSize(width: defaultPadding, height: defaultPadding))
        static let worldMenuBackgroundButton = CGRect(
            origin: sceneCenter,
            size: sceneSize)
        static let exitWorldButton = CGRect(
            origin: enterButton.origin,
            size: exitWorldButtonNodeSize)
        static let escapeButton = CGRect(
            origin: resetButtonNodePosition,
            size: exitWorldButtonNodeSize)
    }

    // MARK: - name
    struct Name {
        static let defaultWorld = "world000"

        // MARK: file name
        static let tileMapFile = "tileMap.dat"
        static let masteryDataModelFile = "masteryDataModel.sqlite"
        static let worldDataModelFile = "worldDataModel.sqlite"
        static let worldDataFile = "worldData.dat"

        // MARK: data model name
        static let worldDataModel = "WorldDataModel"
        static let gameObjectEntity = "GameObjectMO"
        static let invCoordinateEntity = "InventoryCoordinateMO"
        static let chunkCoordinateEntity = "ChunkCoordinateMO"
        static let chunkIsGeneratedEntity = "ChunkIsGeneratedMO"
        static let interactionMasteryEntity = "InteractionMasteryMO"
        static let goInteractionMasteryEntity = "GOInteractionMasteryMO"
        static let craftMasteryEntity = "CraftMasteryMO"
    }

    // MARK: - resource name
    struct ResourceName {
        static let menuButton = "menu button"
        static let inventoryCell = "inventory_cell"
        static let inventoryCellLeftHand = "inventory_cell_left_hand"
        static let inventoryCellRightHand = "inventory_cell_right_hand"
        static let craftCell = "craft_cell"
        static let bgPortal = "bg_portal"
        static let button = "button"
        static let discordButton = "discord_icon"
    }

    // MARK: - recipe
    static let recipes: [GameObjectType: [GameObjectType: Int]] = [
        // MARK: tile
        .woodFloorFloor: [.woodBoard: 2],
        .woodWall: [.woodBoard: 2],

        // MARK: tool
        .axe: [.stone: 1, .woodStick: 1],
        .pickaxe: [.stone: 1, .woodStick: 1],
        .shovel: [.stone: 1, .woodStick: 1],
        .sickle: [.stone: 1, .woodStick: 1],
        .saw: [.stone: 1, .woodStick: 1],

        // MARK: container
        .leafBag: [.weedLeaves: 4],
        .vineBasket: [.vineStem: 4],
        .woodenBox: [.woodBoard: 4],
    ]

    // MARK: - etc
    static let tileCountOfChunkSide: Int = 16
    static let tileMapSide: Int = tileCountOfChunkSide * 3
    static let chunkWidth: Double = tileWidth * Double(tileCountOfChunkSide)

    static let chunkCountOfRegionSide: Int = 16
    static let tileCountOfRegionSide = chunkCountOfRegionSide * tileCountOfChunkSide

    static let velocityDamping = 1000.0
    static let velocityFrictionRatioPerSec = 0.001

    static let sceneScale = 1.0

//    static let minZoomScale = 0.3
    static let minZoomScale = 0.1
    static let maxZoomScale = 1.0

    static let initialNextID = 1

    static let portalEventQueueSize = 2
    static let worldEventQueueSize = 100

    static let accessibleGOColorBlendFactor = 0.5

    static let characterAccessibleRange = 1

    static let panThreshold = tileWidth * 2.0

    static let characterInventoryID = 0

    static let longTouchThreshold = 0.5

    static let timeTookTooRemove = 100.0
    static let weedSpreadTime = 1 * 60.0

    static let aSecond = 1.0
    static let aMinute = aSecond * 60.0
    static let anHour = aMinute * 60.0
    static let aDay = anHour * 24.0
    static let aWeek = aDay * 7.0

    static let timeEventLimit = 5

}
