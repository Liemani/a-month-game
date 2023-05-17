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
        if let storeDescription = self.persistentContainer.persistentStoreDescriptions.first {
            let worldDataModelURL = worldDirectoryURL.appending(path: Constant.gameDataModelFileName)
            storeDescription.url = worldDataModelURL
        }

        self.persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

    // MARK: - edit
    func loadGameObjectManagedObjectArray() -> [GameObjectManagedObject] {
        let request = GameObjectManagedObject.fetchRequest()
        let context = self.persistentContainer.viewContext
        return try! context.fetch(request)
    }

    func store(gameObject: GameObject) {
        let context = self.persistentContainer.viewContext

        let managedObject = NSEntityDescription.insertNewObject(forEntityName: Constant.gameObjectDataEntityName, into: context) as! GameObjectManagedObject

        managedObject.id = Int32(gameObject.id)
        managedObject.inventoryID = Int32(gameObject.coordinate.inventoryID)
        managedObject.row = Int32(gameObject.coordinate.row)
        managedObject.column = Int32(gameObject.coordinate.column)
        managedObject.typeID = Int32(gameObject.typeID)

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

    func delete(gameObject: GameObject) {
        let context = self.persistentContainer.viewContext

        let request = NSFetchRequest<GameObjectManagedObject>(entityName: Constant.gameObjectDataEntityName)
        request.predicate = NSPredicate(format: "id == %@", argumentArray: [gameObject.id])

        let results = try! context.fetch(request)
        let targetObject = results.first!
        context.delete(targetObject)

        try! context.save()
    }

    // MARK: - remove persistentStore
    func removeFirstPersistentStore() {
        let persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        let persistentStore = persistentStoreCoordinator.persistentStores.first!
        try! persistentStoreCoordinator.remove(persistentStore)
    }

}
