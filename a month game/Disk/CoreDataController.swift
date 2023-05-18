//
//  PersistentContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/13.
//

import Foundation
import CoreData

final class CoreDataController {

    var persistentContainer: NSPersistentContainer!

    init() {
        self.persistentContainer = NSPersistentContainer(name: Constant.worldDataModelName)
    }

    func setToWorld(with worldDirectoryURL: URL) {
        let persistentStoreDescription = self.persistentContainer.persistentStoreDescriptions.first!
        let worldDataModelURL = worldDirectoryURL.appending(path: Constant.dataModelFileName)
        persistentStoreDescription.url = worldDataModelURL

        self.persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

    func removeFirstPersistentStore() {
        let persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        let persistentStore = persistentStoreCoordinator.persistentStores.first!
        try! persistentStoreCoordinator.remove(persistentStore)
    }

    // MARK: - edit
    func loadGameObjectManagedObjectArray() -> [GameObjectManagedObject] {
        let request = GameObjectManagedObject.fetchRequest()
        let context = self.persistentContainer.viewContext
        let gameObjectManagedObjectArray = try! context.fetch(request)

        return gameObjectManagedObjectArray.count > 0
            ? gameObjectManagedObjectArray
            : self.generateInitialGameObjectManagedObjectArray()
    }

    func store(_ gameObject: GameObject) {
        let context = self.persistentContainer.viewContext

        let managedObject = NSEntityDescription.insertNewObject(forEntityName: Constant.gameObjectDataEntityName, into: context) as! GameObjectManagedObject

        managedObject.id = Int32(gameObject.id)
        managedObject.typeID = Int32(Resource.getTypeID(of: gameObject))
        managedObject.inventoryID = Int32(gameObject.coordinate.inventoryID)
        managedObject.row = Int32(gameObject.coordinate.row)
        managedObject.column = Int32(gameObject.coordinate.column)

        try! context.save()
    }

    func moveCoordinate(of gameObject: GameObject, to newCoordinate: GameObjectCoordinate) {
        let context = self.persistentContainer.viewContext

        let request = NSFetchRequest<GameObjectManagedObject>(entityName: Constant.gameObjectDataEntityName)
        request.predicate = NSPredicate(format: "id == %@", argumentArray: [gameObject.id])

        let results = try! context.fetch(request)
        let targetObject = results.first!

        targetObject.inventoryID = Int32(newCoordinate.inventoryID)
        targetObject.row = Int32(newCoordinate.row)
        targetObject.column = Int32(newCoordinate.column)

        try! context.save()
    }

    func delete(_ gameObject: GameObject) {
        let context = self.persistentContainer.viewContext

        let request = NSFetchRequest<GameObjectManagedObject>(entityName: Constant.gameObjectDataEntityName)
        request.predicate = NSPredicate(format: "id == %@", argumentArray: [gameObject.id])

        let results = try! context.fetch(request)
        let targetObject = results.first!
        context.delete(targetObject)

        try! context.save()
    }

    // MARK: - private
    private func generateInitialGameObjectManagedObjectArray() -> [GameObjectManagedObject] {
        let idGenerator = IDGenerator.default

        let gameObjectManagedObject = [
            self.store(id: Int32(idGenerator.generate()), typeID: 1, inventoryID: 0, row: 51, column: 51),
            self.store(id: Int32(idGenerator.generate()), typeID: 2, inventoryID: 0, row: 52, column: 52),
            self.store(id: Int32(idGenerator.generate()), typeID: 3, inventoryID: 0, row: 50, column: 53),
            self.store(id: Int32(idGenerator.generate()), typeID: 3, inventoryID: 0, row: 48, column: 51),
            self.store(id: Int32(idGenerator.generate()), typeID: 3, inventoryID: 0, row: 48, column: 52),
        ]

        try! self.persistentContainer.viewContext.save()

        return gameObjectManagedObject
    }

    private func store(id: Int32, typeID: Int32, inventoryID: Int32, row: Int32, column: Int32) -> GameObjectManagedObject {
        let context = self.persistentContainer.viewContext

        let managedObject = NSEntityDescription.insertNewObject(forEntityName: Constant.gameObjectDataEntityName, into: context) as! GameObjectManagedObject

        managedObject.id = id
        managedObject.typeID = typeID
        managedObject.inventoryID = inventoryID
        managedObject.row = row
        managedObject.column = column

        return managedObject
    }

}
