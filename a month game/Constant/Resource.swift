//
//  Resource.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/15.
//

import Foundation
import SpriteKit

struct Resource {

    // MARK: - resource name
    struct Name {
        // MARK: ui
        static let character = "character"
        static let menuButton = "menu button"
        static let inventoryCell = "inventory cell"
        static let bgPortal = "bg_portal"
        static let button = "button"

        // MARK: tile
        static let grassTile = "tile_grass"
        static let woodTile = "tile_wood"

        // MARK: game object
        static let gameObjectDefault = "game_object_default"
        static let gameObjectPineCone = "game_object_pine_cone"
        static let gameObjectPineTree = "game_object_pine_tree"
        static let gameObjectWoodWall = "game_object_wood_wall"
        static let gameObjectStone = "game_object_stone"
        static let gameObjectBranch = "game_object_branch"
        static let gameObjectAxe = "game_object_axe"
    }

    // MARK: - tile
    /// Define tile type
    static let tileTypeToResourceName: [String] = [
        Resource.Name.grassTile,
        Resource.Name.woodTile,
    ]

    static let tileTypeToResource: [(tileGroup: SKTileGroup, tileDefinition: SKTileDefinition)] = ({
        let emptyElement = (SKTileGroup(), SKTileDefinition())
        let count = Resource.tileTypeToResourceName.count
        var array = [(tileGroup: SKTileGroup, tileDefinition: SKTileDefinition)](repeating: emptyElement, count: count)

        for tileType in 0..<Resource.tileTypeToResourceName.count {
            let tileTexture = SKTexture(imageNamed: Resource.tileTypeToResourceName[tileType])
            let tileDefinition = SKTileDefinition(texture: tileTexture)
            let tileGroup = SKTileGroup(tileDefinition: tileDefinition)
            array[tileType] = (tileGroup, tileDefinition)
        }

        return array
    })()

    // MARK: - game object
    /// Define GameObject type
    static let gameObjectTypeIDToInformation: [(type: GameObject.Type, resourceName: String)] = [
        (GameObject.self, Resource.Name.gameObjectDefault),
        (GameObjectPineCone.self, Resource.Name.gameObjectPineCone),
        (GameObjectPineTree.self, Resource.Name.gameObjectPineTree),
        (GameObjectWoodWall.self, Resource.Name.gameObjectWoodWall),
        (GameObjectBranch.self, Resource.Name.gameObjectBranch),
        (GameObjectStone.self, Resource.Name.gameObjectStone),
        (GameObjectAxe.self, Resource.Name.gameObjectAxe),
    ]

    private static let gameObjectTypeIDToResource: [ObjectIdentifier: (typeID: Int, texture: SKTexture)] = ({
        var dictionary: [ObjectIdentifier: (typeID: Int, texture: SKTexture)] = [:]

        for (index, information) in Resource.gameObjectTypeIDToInformation.enumerated() {
            let key = ObjectIdentifier(information.type)
            let texture = SKTexture(imageNamed: information.resourceName)
            let value = (typeID: index, texture: texture)
            dictionary[key] = value
        }

        return dictionary
    })()

    static func getTypeID(of gameObject: GameObject) -> Int {
        let objectIdentifier = ObjectIdentifier(type(of: gameObject))
        return Resource.gameObjectTypeIDToResource[objectIdentifier]!.typeID
    }

    static func getTexture(of gameObject: GameObject) -> SKTexture {
        let objectIdentifier = ObjectIdentifier(type(of: gameObject))
        return Resource.gameObjectTypeIDToResource[objectIdentifier]!.texture
    }

}
