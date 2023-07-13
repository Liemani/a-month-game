//
//  InteractionMasteryDataSource.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/09.
//

import Foundation
import CoreData

class InteractionMasteryDataSource {

    private let moContext: NSManagedObjectContext

    init(_ moContext: NSManagedObjectContext) {
        self.moContext = moContext
    }

    func new() -> InteractionMasteryMO {
        let entityName = Constant.Name.interactionMasteryEntity
        let interactionMasteryMO = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.moContext) as! InteractionMasteryMO
        return interactionMasteryMO
    }

    func load() -> [InteractionMasteryMO] {
        let request = NSFetchRequest<InteractionMasteryMO>(entityName: Constant.Name.interactionMasteryEntity)

        let interactionMasteryMOs = try! self.moContext.fetch(request)
        return interactionMasteryMOs
    }

}
