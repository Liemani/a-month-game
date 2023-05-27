//
//  GameObjectType.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/24.
//

import Foundation
import SpriteKit

enum GameObjectType: Int, CaseIterable {

    case none
    case pineCone
    case pineTree
    case woodWall
    case branch
    case stone
    case axe

    private static let rawResources: [(type: GameObject.Type, name: String)] = [
        (GameObject.self, "game_object_none"),
        (GameObjectPineCone.self, "game_object_pine_cone"),
        (GameObjectPineTree.self, "game_object_pine_tree"),
        (GameObjectWoodWall.self, "game_object_wood_wall"),
        (GameObjectBranch.self, "game_object_branch"),
        (GameObjectStone.self, "game_object_stone"),
        (GameObjectAxe.self, "game_object_axe"),
    ]

    static let resource: [ObjectIdentifier: (type: GameObjectType, typeID: Int, texture: SKTexture)] = ({

        var dictionary: [ObjectIdentifier: (type: GameObjectType, typeID: Int, texture: SKTexture)] = [:]

        for (typeID, rawResource) in rawResources.enumerated() {
            let type = GameObjectType(rawValue: typeID)!
            let objectIdentifier = ObjectIdentifier(rawResource.type)
            let resourceName = rawResource.name
            let texture = SKTexture(imageNamed: resourceName)
            let value = (type: type, typeID: typeID, texture: texture)
            dictionary[objectIdentifier] = value
        }

        return dictionary
    })()

    static var caseCount: Int {
        return GameObjectType.allCases.count
    }

    static func new(typeID: Int) -> GameObject? {
        guard 0 <= typeID && typeID < self.caseCount else { return nil }
        let type = self.rawResources[typeID].type
        let texture = self.resource[ObjectIdentifier(type)]!.texture
        return type.init(texture: texture)
    }

    var metatype: GameObject.Type {
        return GameObjectType.rawResources[self.rawValue].type
    }

    var typeID: Int {
        return self.rawValue
    }

    var texture: SKTexture {
        let objectIdentifier = ObjectIdentifier(self.metatype)
        return GameObjectType.resource[objectIdentifier]!.texture
    }

}
