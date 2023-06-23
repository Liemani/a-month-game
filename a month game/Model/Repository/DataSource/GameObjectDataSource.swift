//
//  PersistentContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/13.
//

import Foundation
import CoreData

final class GameObjectDataSource {

    private let persistentContainer: LMIPersistentContainer

    init(_ persistentContainer: LMIPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    private var moContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    func new() -> GameObjectMO {
        let entityName = Constant.Name.gameObjectEntity
        let goMO = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.moContext) as! GameObjectMO
        return goMO
    }

}
