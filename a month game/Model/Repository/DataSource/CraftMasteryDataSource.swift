//
//  CraftMasteryDataSource.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/09.
//

import Foundation
import CoreData

class CraftMasteryDataSource {

    private let moContext: NSManagedObjectContext

    init(_ moContext: NSManagedObjectContext) {
        self.moContext = moContext
    }

    func new() -> CraftMasteryMO {
        let entityName = Constant.Name.craftMasteryEntity
        let craftMasteryMO = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.moContext) as! CraftMasteryMO
        return craftMasteryMO
    }

    func load() -> [CraftMasteryMO] {
        let request = NSFetchRequest<CraftMasteryMO>(entityName: Constant.Name.craftMasteryEntity)

        let craftMasteryMOs = try! self.moContext.fetch(request)
        return craftMasteryMOs
    }

}
