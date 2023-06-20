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

    func setUp(to worldDirectoryURL: URL) {
        let worldDataModelURL = worldDirectoryURL.appending(path: Constant.Name.worldDataModelFile)
        self.persistentStoreDescriptions[0].url = worldDataModelURL
        self.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

}
