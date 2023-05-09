//
//  MapModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation
import CoreData

class MapModel {

    //    var tileMap: Array<Array<Int>>!
    var tileMapData: Data!
    var tileMap: UnsafeMutableBufferPointer<Int>!
//    = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: 100), count: 100)

    init() {
        let fileManager = FileManager.default

        if !fileManager.fileExists(atPath: Constant.tileMapDataFileURL.path) {
            if !fileManager.fileExists(atPath: Constant.worldDirectoryURL.path) {
                try! fileManager.createDirectory(at: Constant.worldDirectoryURL, withIntermediateDirectories: false)
            }
            fileManager.createFile(atPath: Constant.tileMapDataFileURL.path, contents: Data(count: MemoryLayout<Int>.size * 100 * 100))
        }

        let fileHandle = try! FileHandle(forReadingFrom: Constant.tileMapDataFileURL)
        tileMapData = fileHandle.readData(ofLength: MemoryLayout<Int>.size * Constant.gridSize * Constant.gridSize)

        fileHandle.closeFile()

//        let tileMap11 = tileMapData.withUnsafeBytes {
//            $0.bindMemory(to: Int.self).map({ $0 })
//        }

        tileMap = tileMapData.withUnsafeMutableBytes {
            $0.bindMemory(to: Int.self)
        }
    }

    func setTileData(row: Int, column: Int, tileID: Int) {
        self.tileMap[100 * row + column] = tileID

        var value = tileID
//        let data = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
        let data = withUnsafeBytes(of: &value) { Data($0) }

        let fileHandle = try! FileHandle(forWritingTo: Constant.tileMapDataFileURL)

        try! fileHandle.seek(toOffset: UInt64(Constant.gridSize * row + column))

        fileHandle.write(data)
        fileHandle.closeFile()

//        } catch let error {
//            print("Error saving managed object: \(error)")
//        }



        //        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        //        let newTile = Tile(context: managedContext)
        //
        //        newTile.setValue(row, forKey: #keyPath(Tile.row))
        //        newTile.setValue(column, forKey: #keyPath(Tile.column))
        //        newTile.setValue(tileID, forKey: #keyPath(Tile.tileID))
        //
        //        AppDelegate.sharedAppDelegate.coreDataStack.saveContext() // Save changes in CoreData

//        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            // handle error
//            return
//        }
//
//        let fileURL = documentsDirectory.appendingPathComponent("example.txt")
//
//        let data = "Hello, world!".data(using: .utf8)
//        do {
//            try data?.write(to: fileURL)
//        } catch {
//            // handle error
//            print(error)
//        }
    }

    //    func tileChanged(row: Int, column: Int, value: Int) {
//        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
//
//        // Initialize Core Data stack
//        let container = NSPersistentContainer(name: "MyCoreDataModel")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error {
//                print("Error loading persistent store: \(error)")
//            }
//        })
//
//        tileMapData[row][column] = value
//
//        let entity = NSEntityDescription.entity(forEntityName: "MapData", in: container.viewContext)!
//        let newData = NSManagedObject(entity: entity, insertInto: container.viewContext)
//        newData.setValue(row, forKey: "row")
//        newData.setValue(column, forKey: "column")
//        newData.setValue(value, forKey: "value")
//
//        do {
//            try container.viewContext.save()
//        } catch let error {
//            print("Error saving managed object: \(error)")
//        }
//    }

}
