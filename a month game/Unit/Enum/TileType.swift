//
//  TileType.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

enum TileType: Int, CaseIterable {

    case grass
    case woodFloor

    static var caseCount: Int {
        return self.allCases.count
    }

    private static let resource: [TileType: (tileGroup: SKTileGroup, tileDefinition: SKTileDefinition)] = ({
        let rawResources = [
            "grass_tile",
            "wood_floor",
        ]

        var dictionary: [TileType: (tileGroup: SKTileGroup, tileDefinition: SKTileDefinition)] = [:]

        for tileType in TileType.allCases {
            let resourceName = rawResources[tileType.rawValue]
            let tileTexture = SKTexture(imageNamed: resourceName)
            let tileDefinition = SKTileDefinition(texture: tileTexture)
            let tileGroup = SKTileGroup(tileDefinition: tileDefinition)
            dictionary[tileType] = (tileGroup, tileDefinition)
        }

        return dictionary
    })()

    static var tileGroups: [SKTileGroup] {
        return TileType.resource.values.map { $0.tileGroup }
    }

    var tileGroup: SKTileGroup {
        return TileType.resource[self]!.tileGroup
    }

    var tileDefinition: SKTileDefinition {
        return TileType.resource[self]!.tileDefinition
    }

}
