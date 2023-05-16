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
    func loadGameObjectDataArray() -> [GameItemData] {
        let fetchRequest = GameItemData.fetchRequest()
        let context = self.persistentContainer.viewContext
        return try! context.fetch(fetchRequest)
    }

    func store(gameObject: GameObject) {
        let context = self.persistentContainer.viewContext
        let gameItemData = NSEntityDescription.insertNewObject(forEntityName: Constant.gameItemDataEntityName, into: context) as! GameItemData
        gameItemData.id = Int32(gameObject.id)
        gameItemData.inventoryID = Int32(gameObject.position.inventoryID)
        gameItemData.row = Int32(gameObject.position.row)
        gameItemData.column = Int32(gameObject.position.column)
        gameItemData.typeID = Int32(gameObject.typeID)

        try! self.persistentContainer.viewContext.save()
    }

    func delete(gameObject: GameObject) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.gameItemDataEntityName)
        request.predicate = NSPredicate(format: "id == %@", argumentArray: [gameObject.id])

        do {
            let context = self.persistentContainer.viewContext
            let results = try context.fetch(request)
            if results.count > 0 {
                let objectToDelete = results[0] as! NSManagedObject
                context.delete(objectToDelete)
                try context.save()
            }
        } catch {
            print("Error deleting object: \(error)")
        }
    }

    // MARK: - remove persistentStore
    func removeFirstPersistentStore() {
        let persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        let persistentStore = persistentStoreCoordinator.persistentStores.first!
        try! persistentStoreCoordinator.remove(persistentStore)
    }

}

//    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
//        let context = backgroundContext ?? viewContext
//        guard context.hasChanges else { return }
//
//        try! context.save()
//    }

//    func saveNewGameItemData(gameItem: GameItem) {
//        var itemEntity = GameItemData()
//        let newItem = NSManagedObject(entity: itemEntity, insertInto: managedObjectContext)
//        newItem.setValue(gameItem.id, forKey: "id")
//        newItem.setValue(gameItem.position.inventoryID, forKey: "inventoryID")
//        newItem.setValue(gameItem.position.row, forKey: "row")
//        newItem.setValue(gameItem.position.column, forKey: "column")
//
//        try! managedObjectContext.save()
//    }

//    func loadGameItemData() {
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameItemData")
//        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
//        fetchRequest.predicate = NSPredicate(format: "row == %@", argumentArray: [row])
//        fetchRequest.predicate = NSPredicate(format: "column == %@", argumentArray: [column])
//
//        let gameItem = GameItem(name: name, quantity: quantity, value: value)
//        gameItem.id = id
//    }
