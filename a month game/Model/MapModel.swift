//
//  MapModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation
import CoreData

class MapModel {
    var tileMapData: Array<Array<Int>> = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: 100), count: 100)

    func tileChanged(row: Int, column: Int, value: Int) {
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()

        // Initialize Core Data stack
        let container = NSPersistentContainer(name: "MyCoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                print("Error loading persistent store: \(error)")
            }
        })

        tileMapData[row][column] = value

        let entity = NSEntityDescription.entity(forEntityName: "MapData", in: container.viewContext)!
        let newData = NSManagedObject(entity: entity, insertInto: container.viewContext)
        newData.setValue(row, forKey: "row")
        newData.setValue(column, forKey: "column")
        newData.setValue(value, forKey: "value")

        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving managed object: \(error)")
        }
    }

    func loadData() {
    }

    func setTileData(row: Int, column: Int, tileID: Int) {
        self.tileMapData[row][column] = tileID
    }
}
