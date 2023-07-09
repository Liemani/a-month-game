//
//  InteractionMasteryDataSource.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/09.
//

import Foundation
import CoreData

class GOInteractionMasteryDataSource {

    private let moContext: NSManagedObjectContext

    init(_ moContext: NSManagedObjectContext) {
        self.moContext = moContext
    }

    func new() -> GOInteractionMasteryMO {
        let entityName = Constant.Name.goInteractionMasteryEntity
        let goInteractionMasteryMO = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.moContext) as! GOInteractionMasteryMO
        return goInteractionMasteryMO
    }

    func load() -> [GOInteractionMasteryMO] {
        let request = NSFetchRequest<GOInteractionMasteryMO>(entityName: Constant.Name.goInteractionMasteryEntity)

        let goInteractionMasteryMOs = try! self.moContext.fetch(request)
        return goInteractionMasteryMOs
    }

}
