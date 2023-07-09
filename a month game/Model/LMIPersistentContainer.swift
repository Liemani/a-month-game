//
//  LMIPersistentContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/17.
//

import Foundation
import CoreData

class LMIPersistentContainer: NSPersistentContainer {

    init(name: String) {
        let worldDataModelURL = Bundle.main.url(forResource: name, withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: worldDataModelURL)!
        super.init(name: name, managedObjectModel: managedObjectModel)
    }

    func setUp(to worldDirURL: URL) {
        let characterDataModelURL = worldDirURL.deletingLastPathComponent().appending(path: Constant.Name.masteryDataModelFile)
        let worldDataModelURL = worldDirURL.appending(path: Constant.Name.worldDataModelFile)

        let characterStoreDescription = NSPersistentStoreDescription()
        characterStoreDescription.configuration = "Character"
        characterStoreDescription.type = NSSQLiteStoreType
        characterStoreDescription.url = characterDataModelURL

        let worldStoreDescription = NSPersistentStoreDescription()
        worldStoreDescription.configuration = "World"
        worldStoreDescription.type = NSSQLiteStoreType
        worldStoreDescription.url = worldDataModelURL

        self.persistentStoreDescriptions = [characterStoreDescription, worldStoreDescription]

        self.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

}
