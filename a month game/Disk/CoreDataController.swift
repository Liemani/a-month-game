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
        managedObject.inventory = Int32(gameObject.coordinate.inventory)
        managedObject.x = Int32(gameObject.coordinate.x)
        managedObject.y = Int32(gameObject.coordinate.y)

        try! context.save()
    }

    func moveCoordinate(of gameObject: GameObject, to newCoordinate: GameObjectCoordinate) {
        let context = self.persistentContainer.viewContext

        let request = NSFetchRequest<GameObjectManagedObject>(entityName: Constant.gameObjectDataEntityName)
        request.predicate = NSPredicate(format: "id == %@", argumentArray: [gameObject.id])

        let results = try! context.fetch(request)
        let targetObject = results.first!

        targetObject.inventory = Int32(newCoordinate.inventory)
        targetObject.x = Int32(newCoordinate.x)
        targetObject.y = Int32(newCoordinate.y)

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
            self.store(typeID: 1, id: Int32(idGenerator.generate()), inventory: 0, x: 51, y: 51),
            self.store(typeID: 2, id: Int32(idGenerator.generate()), inventory: 0, x: 52, y: 52),
            self.store(typeID: 3, id: Int32(idGenerator.generate()), inventory: 0, x: 50, y: 53),
            self.store(typeID: 3, id: Int32(idGenerator.generate()), inventory: 0, x: 48, y: 51),
            self.store(typeID: 3, id: Int32(idGenerator.generate()), inventory: 0, x: 48, y: 52),
        ]

        try! self.persistentContainer.viewContext.save()

        return gameObjectManagedObject
    }

    private func store(typeID: Int32, id: Int32, inventory: Int32, x: Int32, y: Int32) -> GameObjectManagedObject {
        let context = self.persistentContainer.viewContext

        let managedObject = NSEntityDescription.insertNewObject(forEntityName: Constant.gameObjectDataEntityName, into: context) as! GameObjectManagedObject

        managedObject.typeID = typeID
        managedObject.id = id
        managedObject.inventory = inventory
        managedObject.x = x
        managedObject.y = y

        return managedObject
    }

}
