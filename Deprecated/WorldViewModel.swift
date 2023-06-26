//
//  WorldViewModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/19.
//

//import Foundation
//import SpriteKit
//
//class WorldViewModel {
//
//    let movingLayer: MovingLayer
//
//    var chunkContainer: ChunkContainer
//
//    let characterInv: any InventoryProtocol
//
//    var fieldInv: (any InventoryProtocol)?
//    var characterInvInv: (any InventoryProtocol)?
//
//    let character: Character
//
//
////    var interactableGOs: [GameObject] {
////        var interactableGOs = [GameObjectNode]()
////
////        for go in self.chunkContainer.gos {
////            let characterCoord = self.characterMoveTouchEventHandler.
////            if go.intersects(interactionZone) {
////                interactableGOs.append(child)
////            }
////        }
////        return interactableGOs
////    }
//
//    // MARK: - init
//    init(movingLayer: MovingLayer,
//         chunkContainer: ChunkContainer,
//         characterInv: any InventoryProtocol,
//         fieldInv: (any InventoryProtocol)? = nil,
//         characterInvInv: (any InventoryProtocol)? = nil,
//         character: Character) {
//        self.movingLayer = movingLayer
//        self.chunkContainer = chunkContainer
//        self.characterInv = characterInv
//        self.fieldInv = fieldInv
//        self.characterInvInv = characterInvInv
//        self.character = character
//
//        self.accessableGOTracker = AccessableGOTracker()
//        WorldUpdateManager.default.update(with: .interaction)
//    }
//
//}
