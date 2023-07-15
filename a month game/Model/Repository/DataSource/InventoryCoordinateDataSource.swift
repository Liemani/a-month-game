//
//  InventoryCoordinateRepository.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/18.
//

import Foundation
import CoreData

class InventoryCoordinateDataSource {

    private let moContext: NSManagedObjectContext

    init(_ moContext: NSManagedObjectContext) {
        self.moContext = moContext
    }

    func new() -> InventoryCoordinateMO {
        let entityName = Constant.Name.invCoordinateEntity
        let invCoordMO = NSEntityDescription.insertNewObject(
            forEntityName: entityName, into: self.moContext) as! InventoryCoordinateMO
        return invCoordMO
    }

    func load(id: Int) -> [InventoryCoordinateMO] {
        let request = NSFetchRequest<InventoryCoordinateMO>(
            entityName: Constant.Name.invCoordinateEntity)
        request.predicate = NSPredicate(format: "id == %@", argumentArray: [id])

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
        Services.default.moContext.delete(self)
    }

}
