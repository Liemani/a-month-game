//
//  PersistentContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/13.
//

import Foundation
import CoreData

final class GameObjectDataSource {

    private let moContext: NSManagedObjectContext

    init(_ moContext: NSManagedObjectContext) {
        self.moContext = moContext
    }

    func new() -> GameObjectMO {
        let entityName = Constant.Name.gameObjectEntity
        let goMO = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.moContext) as! GameObjectMO
        return goMO
    }

}
