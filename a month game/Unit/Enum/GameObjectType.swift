//
//  GameObjectType.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/24.
//

import Foundation
import SpriteKit

enum GameObjectType: Int, CaseIterable {

    typealias ResourceType = (
        resourceName: String,
        isWalkable: Bool,
        isPickable: Bool,
        isInteractable: Bool,
        isTile: Bool
    )

    case none
    case woodFloor
    case pineCone
    case pineTree
    case woodWall
    case woodStick
    case stone
    case axe

    #warning("todo")
    // set isTile
    // remove tile thing

    private static let resources: [ResourceType] = [
        ("game_object_none", false, false, false, false),
        ("game_object_wood_floor", true, false, false, true),
        ("game_object_pine_cone", true, true, true, false),
        ("game_object_pine_tree", false, false, true, false),
        ("game_object_wood_wall", false, false, true, false),
        ("game_object_wood_stick", true, true, true, false),
        ("game_object_stone", true, true, true, false),
        ("game_object_axe", true, true, true, false),
    ]

    private static let textures: [SKTexture] = ({
        var textures: [SKTexture] = [SKTexture](repeating: SKTexture(), count: GameObjectType.caseCount)

        for (index, resource) in resources.enumerated() {
            let texture = SKTexture(imageNamed: resource.resourceName)
            texture.filteringMode = .nearest
            textures[index] = texture
        }

        return textures
    })()

    static var caseCount: Int { GameObjectType.allCases.count }

    var typeID: Int32 { Int32(self.rawValue) }
    var resources: [ResourceType] { GameObjectType.resources }
    var texture: SKTexture { GameObjectType.textures[self.rawValue] }

    var isWalkable: Bool { self.resources[self.rawValue].isWalkable }
    var isPickable: Bool { self.resources[self.rawValue].isPickable }
    var isInteractable: Bool { self.resources[self.rawValue].isInteractable }
    var isTile: Bool { self.resources[self.rawValue].isTile }

}
