//
//  GameObjectModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/16.
//

import Foundation

class GameObjectsModel {

    private let service: GameObjectService

    private var idGenerator: IDGenerator
    let goMOGO: GOMOGO

    private var needContextSave: Bool

    init(serviceContainer: WorldServiceContainer) {
        self.service = serviceContainer.gameObjectService

        self.idGenerator = IDGenerator(worldDataService: serviceContainer.worldDataService)
        self.goMOGO = GOMOGO()
        self.needContextSave = false
    }

    // MARK: - from world view model
    func loadGOMOs() -> [GameObjectMO] {
        return self.service.load()
    }

    func contextSaveIfNeed() {
        guard self.needContextSave else { return }

        self.service.contextSave()
        self.needContextSave = false
    }

    func newGOMO(of goType: GameObjectType, to goCoord: GameObjectCoordinate) -> GameObjectMO {
        let newGOMO = self.service.newGOMO()
        newGOMO.set(id: self.idGenerator.generate(), gameObjectType: goType, goCoord: goCoord)
        self.needContextSave = true
        return newGOMO
    }

    func setGOMO(_ goMO: GameObjectMO, to goCoord: GameObjectCoordinate) {
        goMO.set(to: goCoord)
        self.needContextSave = true
    }

    func remove(_ goMO: GameObjectMO) {
        self.service.delete(goMO)
        self.needContextSave = true
    }

}
