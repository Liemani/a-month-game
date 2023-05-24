//
//  PersistentContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/13.
//

import Foundation
import CoreData

final class PersistentContainer: NSPersistentContainer {

    func setToWorld(with worldDirectoryURL: URL) {
        print(self.persistentStoreDescriptions.count)
        print(self.persistentStoreCoordinator.persistentStores.count)
        self.loadPersistentStore(from: worldDirectoryURL)
    }

    func loadPersistentStore(from directoryURL: URL) {
        let worldDataModelURL = directoryURL.appending(path: Constant.dataModelFileName)
        self.persistentStoreDescriptions[0].url = worldDataModelURL

        self.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

    func removeFirstPersistentStore() {
        let persistentStoreCoordinator = self.persistentStoreCoordinator
        let persistentStore = persistentStoreCoordinator.persistentStores.first!
        try! persistentStoreCoordinator.remove(persistentStore)
    }

    // MARK: - edit
    func fetchGameObjectMOArray() -> [GameObjectMO] {
        let request = GameObjectMO.fetchRequest()
        let gameObjectManagedObjectArray = try! self.viewContext.fetch(request)

        return gameObjectManagedObjectArray.count > 0
            ? gameObjectManagedObjectArray
            : self.generateGameObjectMOArray()
    }

    func store(_ gameObjectMO: GameObjectMO) {
        let context = self.viewContext

        context.insert(gameObjectMO)

        try! context.save()
    }

    func contextSave() {
        let context = self.viewContext

        try! context.save()
    }

    func delete(_ gameObjectMO: GameObjectMO) {
        let context = self.viewContext

        context.delete(gameObjectMO)

        try! context.save()
    }

    // MARK: - private
    private func generateGameObjectMOArray() -> [GameObjectMO] {
        let idGenerator = IDGenerator.default

        let gameObjectManagedObject = [
            self.store(typeID: 1, id: Int32(idGenerator.generate()), containerID: 0, x: 51, y: 51),
            self.store(typeID: 2, id: Int32(idGenerator.generate()), containerID: 0, x: 52, y: 52),
            self.store(typeID: 3, id: Int32(idGenerator.generate()), containerID: 0, x: 50, y: 53),
            self.store(typeID: 3, id: Int32(idGenerator.generate()), containerID: 0, x: 48, y: 51),
            self.store(typeID: 3, id: Int32(idGenerator.generate()), containerID: 0, x: 48, y: 52),
            self.store(typeID: 4, id: Int32(idGenerator.generate()), containerID: 0, x: 48, y: 53),
            self.store(typeID: 5, id: Int32(idGenerator.generate()), containerID: 0, x: 48, y: 54),
        ]

        try! self.viewContext.save()

        return gameObjectManagedObject
    }

    private func store(typeID: Int32, id: Int32, containerID: Int32, x: Int32, y: Int32) -> GameObjectMO {
        let context = self.viewContext

        let managedObject = NSEntityDescription.insertNewObject(forEntityName: Constant.gameObjectDataEntityName, into: context) as! GameObjectMO

        managedObject.typeID = typeID
        managedObject.id = id
        managedObject.containerID = containerID
        managedObject.x = x
        managedObject.y = y

        return managedObject
    }

}
