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

    private static let resources: [(isWalkable: Bool, isPickable: Bool, resourceName: String)] = [
        // TODO: resource name first and make numbers file for data table
        (true, true, "game_object_none"),
        (true, true, "game_object_pine_cone"),
        (false, false, "game_object_pine_tree"),
        (false, false, "wood_wall"),
        (true, true, "game_object_branch"),
        (true, true, "game_object_stone"),
        (true, true, "game_object_axe"),
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
    var resources: [(isWalkable: Bool, isPickable: Bool, resourceName: String)] { GameObjectType.resources }
    var texture: SKTexture { GameObjectType.textures[self.rawValue] }
    var isWalkable: Bool { self.resources[self.rawValue].isWalkable }
    var isPickable: Bool { self.resources[self.rawValue].isPickable }

}
