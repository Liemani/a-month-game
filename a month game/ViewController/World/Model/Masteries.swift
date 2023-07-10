//
//  MasteriesData.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/09.
//

import Foundation

struct GOInteractionMasteryDatasKey: Hashable {

    let srcType: GameObjectType
    let dstType: GameObjectType

    init(from srcType: GameObjectType, to dstType: GameObjectType) {
        self.srcType = srcType
        self.dstType = dstType
    }

}

class Masteries {

    var interactionMasteryDatas: [GameObjectType: InteractionMasteryData]
    var goInteractionMasteryDatas: [GOInteractionMasteryDatasKey: GOInteractionMasteryData]
    var craftMasteryDatas: [GameObjectType: CraftMasteryData]

    init() {
        self.interactionMasteryDatas = [:]
        self.goInteractionMasteryDatas = [:]
        self.craftMasteryDatas = [:]

        let interactionMasteryDatas = Services.default.interactionMasteryServ.load()

        for interactionMasteryData in interactionMasteryDatas {
            self.interactionMasteryDatas[interactionMasteryData.dstType] = interactionMasteryData
        }

        let goInteractionMasteryDatas = Services.default.goInteractionMasteryServ.load()

        for goInteractionMasteryData in goInteractionMasteryDatas {
            let key = GOInteractionMasteryDatasKey(
                from: goInteractionMasteryData.srcType,
                to: goInteractionMasteryData.dstType)
            self.goInteractionMasteryDatas[key] = goInteractionMasteryData
        }

        let craftMasteryDatas = Services.default.craftMasteryServ.load()

        for craftMasteryData in craftMasteryDatas {
            self.craftMasteryDatas[craftMasteryData.dstType] = craftMasteryData
        }
    }

    func updateInteraction(_ dstType: GameObjectType, exp: Int) {
        if let interactionMasteryData = self.interactionMasteryDatas[dstType] {
            interactionMasteryData.increase(exp: exp)

            return
        }

        let interactionMasteryData = InteractionMasteryData(type: dstType)
        self.interactionMasteryDatas[interactionMasteryData.dstType] = interactionMasteryData
        interactionMasteryData.increase(exp: exp)
    }

    func updateInteraction(with srcType: GameObjectType, to dstType: GameObjectType, exp: Int) {
        let key = GOInteractionMasteryDatasKey(from: srcType, to: dstType)

        if let goInteractionMasteryData = self.goInteractionMasteryDatas[key] {
            goInteractionMasteryData.increase(exp: exp)

            return
        }

        let goInteractionMasteryData = GOInteractionMasteryData(from: srcType, to: dstType)
        self.goInteractionMasteryDatas[key] = goInteractionMasteryData
        goInteractionMasteryData.increase(exp: exp)
    }

    func updateCraft(_ dstType: GameObjectType, exp: Int) {
        if let craftMasteryData = self.craftMasteryDatas[dstType] {
            craftMasteryData.increase(exp: exp)

            return
        }

        let craftMasteryData = CraftMasteryData(type: dstType)
        self.craftMasteryDatas[craftMasteryData.dstType] = craftMasteryData
        craftMasteryData.increase(exp: exp)
    }

}
