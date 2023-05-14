//
//  PersistentContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/13.
//

import Foundation
import CoreData

final class PersistentContainer {

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

    func loadGameItemDataArray() -> [GameItemData] {
        let fetchRequest = GameItemData.fetchRequest()
        return try! self.persistentContainer.viewContext.fetch(fetchRequest)
    }

    func saveGameItem(gameItem: GameItem) {
        let gameItemData = NSEntityDescription.insertNewObject(forEntityName: "GameItemData", into: self.persistentContainer.viewContext) as! GameItemData
        gameItemData.typeID = Int32(gameItem.typeID)
        gameItemData.inventoryID = Int32(gameItem.position.inventoryID)
        gameItemData.row = Int32(gameItem.position.row)
        gameItemData.column = Int32(gameItem.position.column)

        try! self.persistentContainer.viewContext.save()
    }

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
