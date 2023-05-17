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
        static let character = "character"
        static let menuButton = "menu button"
        static let inventoryCell = "inventory cell"
        static let bgPortal = "bg_portal"
        static let button = "button"

        static let grassTile = "tile_grass"
        static let woodTile = "tile_wood"

        static let gameObjectDefault = "game_object_default"
        static let gameObjectPineCone = "game_object_pine_cone"
        static let gameObjectPineTree = "game_object_pine_tree"
        static let gameObjectWoodWall = "game_object_wood_wall"
    }

    // MARK: - tile
    static let tileTypeIDToResourceName: [String] = [
        Resource.Name.grassTile,
        Resource.Name.woodTile,
    ]

    static let tileResourceArray: [(tileGroup: SKTileGroup, tileDefinition: SKTileDefinition)] = ({
        var array = [(tileGroup: SKTileGroup, tileDefinition: SKTileDefinition)](repeating: (SKTileGroup(), SKTileDefinition()), count: Resource.tileTypeIDToResourceName.count)

        for tileTypeID in 0..<Resource.tileTypeIDToResourceName.count {
            let tileTexture = SKTexture(imageNamed: Resource.tileTypeIDToResourceName[tileTypeID])
            let tileDefinition = SKTileDefinition(texture: tileTexture)
            let tileGroup = SKTileGroup(tileDefinition: tileDefinition)
            array[tileTypeID] = (tileGroup, tileDefinition)
        }

        return array
    })()

    // MARK: - game object
    static let gameObjectTypeIDToInformation: [(gameObjectType: GameObject.Type, resourceName: String)] = [
        (GameObject.self, Resource.Name.gameObjectDefault),
        (GameObjectPineCone.self, Resource.Name.gameObjectPineCone),
        (GameObjectPineTree.self, Resource.Name.gameObjectPineTree),
        (GameObjectWoodWall.self, Resource.Name.gameObjectWoodWall),
    ]

    private static let gameObjectResourceDictionary: [ObjectIdentifier: (typeID: Int, texture: SKTexture)] = ({
        var dictionary: [ObjectIdentifier: (typeID: Int, texture: SKTexture)] = [:]

        for (index, information) in Resource.gameObjectTypeIDToInformation.enumerated() {
            let key = ObjectIdentifier(information.gameObjectType)
            let texture = SKTexture(imageNamed: information.resourceName)
            let value = (typeID: index, texture: texture)
            dictionary[key] = value
        }

        return dictionary
    })()

    static func getTypeID(of gameObject: GameObject) -> Int {
        let objectIdentifier = ObjectIdentifier(type(of: gameObject))
        return Resource.gameObjectResourceDictionary[objectIdentifier]!.typeID
    }

    static func getTexture(of gameObject: GameObject) -> SKTexture {
        let objectIdentifier = ObjectIdentifier(type(of: gameObject))
        return Resource.gameObjectResourceDictionary[objectIdentifier]!.texture
    }

}
