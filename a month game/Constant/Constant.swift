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
    static let tileSide = Constant.defaultSize

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

    // MARK: world scene
    static let defaultNodeSize = CGSize(width: defaultSize, height: defaultSize)

    static let tileMapSide = Constant.tileSide * Double(Constant.gridSize)
    static let tileMapNodePosition = CGPoint() + (Constant.tileMapSide / 2.0)

    static let menuPosition = (Constant.sceneSize - Constant.defaultSize).toCGPoint()
    static let characterRadius = Constant.defaultSize - 2.0
    static let exitWorldButtonSize = CGSize(width: defaultSize * 3, height: defaultSize)

    static let inventoryCellCount = 5
    static let inventoryCellFirstPosition = CGPoint() + Constant.defaultSize
    static let inventoryCellLastPosition = CGPoint(x: Constant.sceneSize.width - defaultSize, y: defaultSize)

    // MARK: - z position
    struct ZPosition {
        static let movingLayer = -1.0
        static let background = -2.0
        static let gameObjectField = 0.0

        static let fixedLayer = 1.0
        static let ui = 0.0
        static let menu = 2.0
    }

    // MARK: - frame
    struct Frame {
        static let character = CGRect(origin: Constant.sceneCenter, size: Constant.defaultNodeSize)
        static let menuButton = CGRect(origin: menuPosition, size: CGSize(width: defaultSize, height: defaultSize))
        static let enterButton = CGRect(origin: enterButtonPosition, size: enterButtonSize)
        static let resetButton = CGRect(origin: resetButtonPosition, size: resetButtonSize)
        static let exitWorldButton = CGRect(origin: Constant.sceneCenter, size: exitWorldButtonSize)
    }

    // MARK: - data
    static let defaultWorldName = "world000"
    static let tileMapFileName = "tileMap.dat"
    static let dataModelFileName = "DataModel.sqlite"
    static let worldDataModelName = "DataModel"
    static let gameObjectDataEntityName = "GameObjectManagedObject"

    // MARK: - UserDefaults key
    static let idGenerator = "idGenerator"

    // MARK: - etc
    static let gridSize: Int = 100

    static let velocityDamping = 1000.0
    static let velocityFrictionRatioPerSec = 0.001

}
