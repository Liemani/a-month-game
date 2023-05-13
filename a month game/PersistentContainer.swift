//
//  PersistentContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/13.
//

import Foundation
import CoreData

class PersistentContainer: NSPersistentContainer {

    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }

        try! context.save()
    }

    func loadGameItemData() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameItemDataModel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        fetchRequest.predicate = NSPredicate(format: "row == %@", argumentArray: [row])
        fetchRequest.predicate = NSPredicate(format: "column == %@", argumentArray: [column])

        let gameItem = GameItem(name: name, quantity: quantity, value: value)
        gameItem.id = id
    }

    func saveNewGameItemData(gameItem: GameItem) {
        var itemEntity = GameItemDataModel()
        let newItem = NSManagedObject(entity: itemEntity, insertInto: managedObjectContext)
        newItem.setValue(gameItem.id, forKey: "id")
        newItem.setValue(gameItem.position.inventoryID, forKey: "inventoryID")
        newItem.setValue(gameItem.position.row, forKey: "row")
        newItem.setValue(gameItem.position.column, forKey: "column")

        try! managedObjectContext.save()
    }

}
