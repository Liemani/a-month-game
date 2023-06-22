//
//  InventoryCoordinateRepository.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/18.
//

import Foundation
import CoreData

class InventoryCoordinateDataSource {

    private var moContext: NSManagedObjectContext

    init(_ persistentContainer: LMIPersistentContainer) {
        self.moContext = persistentContainer.viewContext
    }

    func new() -> InventoryCoordinateMO {
        let entityName = Constant.Name.invCoordinateEntity
        let invCoordMO = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.moContext) as! InventoryCoordinateMO
        return invCoordMO
    }

    func load(at invCoord: InventoryCoordinate) -> [InventoryCoordinateMO] {
        let request = NSFetchRequest<InventoryCoordinateMO>(entityName: Constant.Name.invCoordinateEntity)
        request.predicate = NSPredicate(format: "id == %@", argumentArray: [invCoord.id])

        let invCoordMOs = try! self.moContext.fetch(request)
        return invCoordMOs
    }

}

extension InventoryCoordinateMO {

    func update(_ invCoord: InventoryCoordinate) {
        self.id = Int32(invCoord.id)
        self.index = Int32(invCoord.index)
    }

    func delete() {
        WorldServiceContainer.default.moContext.delete(self)
    }

}
