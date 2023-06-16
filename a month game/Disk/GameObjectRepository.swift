//
//  PersistentContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/13.
//

import Foundation
import CoreData

final class GameObjectRepository {

    private let persistentContainer: NSPersistentContainer

    init(worldDirectoryURL: URL) {
        self.persistentContainer = NSPersistentContainer(name: Constant.worldDataModelName)
        self.loadPersistentStore(worldDirectoryURL: worldDirectoryURL)
    }

    private func loadPersistentStore(worldDirectoryURL: URL) {
        let worldDataModelURL = worldDirectoryURL.appending(path: Constant.dataModelFileName)
        self.persistentContainer.persistentStoreDescriptions[0].url = worldDataModelURL
        self.persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

    // MARK: - edit
    func load() -> [GameObjectMO] {
        let request = GameObjectMO.fetchRequest()
        let goMOs = try! self.persistentContainer.viewContext.fetch(request)
        return goMOs
    }

    func load(at chunkCoord: ChunkCoordinate) -> [GameObjectMO] {
        let context = self.persistentContainer.viewContext

        let request = NSFetchRequest<GameObjectMO>(entityName: Constant.gameObjectDataEntityName)
        request.predicate = NSPredicate(format: "chunkX = %@ AND chunkY = %@ AND chunkLocation == %@", argumentArray: [chunkCoord.chunkX, chunkCoord.chunkY, chunkCoord.chunkLocation])

        return try! context.fetch(request)
    }

    func store(_ goMO: GameObjectMO) {
        let context = self.persistentContainer.viewContext
        context.insert(goMO)
    }

    func newMO() -> GameObjectMO {
        let context = self.persistentContainer.viewContext
        let entityName = Constant.gameObjectDataEntityName
        let goMO = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! GameObjectMO
        return goMO
    }

    func delete(_ goMO: GameObjectMO) {
        let context = self.persistentContainer.viewContext
        context.delete(goMO)
    }

    func contextSave() {
        let context = self.persistentContainer.viewContext
        try! context.save()
    }

}
