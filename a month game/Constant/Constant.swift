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

    // MARK: - position, size
    static let screenSize = CGSize(width: 750 * 2, height: 1334 * 2)
    static let screenDownLeft = CGPoint(x: -screenSize.width / 2, y: -screenSize.height / 2)
    static let screenUpRight = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)

    static let defaultNodeSize = CGSize(width: defaultSize, height: defaultSize)
    static let menuPosition = CGPoint(x: screenSize.width / 2 - defaultSize, y: screenSize.height / 2 - defaultSize)
    static let enterButtonPosition = screenUpRight
    static let enterButtonSize = CGSize(width: defaultSize * 3, height: defaultSize)
    static let resetButtonPosition = CGPoint(x: screenUpRight.x, y: screenUpRight.y - defaultSize * 2)
    static let resetButtonSize = CGSize(width: defaultSize * 2, height: defaultSize)
    static let exitWorldButtonSize = CGSize(width: defaultSize * 3, height: defaultSize)

    static let itemNodeSize = CGSize(width: 100.0, height: 100.0)

    static let tileMapSide = Constant.defaultSize * Double(Constant.gridSize)
    static let tileMapNodePosition = CGPoint(x: Constant.tileMapSide / 2.0, y: Constant.tileMapSide / 2.0)

    static let inventoryCellCount = 5
    static let inventoryCellFirstPosition = CGPoint(x: screenDownLeft.x + defaultSize, y: screenDownLeft.y + defaultSize)
    static let inventoryCellLastPosition = CGPoint(x: screenUpRight.x - defaultSize, y: screenDownLeft.y + defaultSize)

    // MARK: - z position
    static let tileMapNodeZPosition = -1.0
    static let worldObjectLayerZPosition = 0.0
    static let uiLayerZPosition = 1.0
    static let menuLayerZPosition = 2.0

    // MARK: - frame
    struct Frame {
        static let character = CGRect(origin: CGPoint(), size: CGSize(width: defaultSize, height: defaultSize))
        static let menuButton = CGRect(origin: menuPosition, size: CGSize(width: defaultSize, height: defaultSize))
        static let enterButton = CGRect(origin: enterButtonPosition, size: enterButtonSize)
        static let resetButton = CGRect(origin: resetButtonPosition, size: resetButtonSize)
        static let exitWorldButton = CGRect(origin: CGPoint(), size: exitWorldButtonSize)
    }

    // MARK: - data
    static let defaultWorldName = "world000"
    static let tileMapFileName = "tileMap.dat"
    static let gameDataModelFileName = "GameDataModel.sqlite"
    static let worldDataModelName = "GameDataModel"
    static let gameObjectDataEntityName = "GameItemData"

    // MARK: - UserDefaults key
    static let idGenerator = "idGenerator"

    // MARK: - etc
    static let gridSize: Int = 100

    static let velocityDamping = 5000.0

}
