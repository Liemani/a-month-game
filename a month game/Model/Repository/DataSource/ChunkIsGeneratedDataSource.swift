//
//  ChunkIsGeneratedDataSource.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/15.
//

import Foundation
import CoreData

class ChunkIsGeneratedDataSource {

    typealias MOType = ChunkIsGeneratedMO

    var entityName: String { Constant.Name.chunkIsGeneratedEntity }

    private let moContext: NSManagedObjectContext

    init(_ moContext: NSManagedObjectContext) {
        self.moContext = moContext
    }

    func new() -> MOType {
        let chunkCoordMO = NSEntityDescription.insertNewObject(
            forEntityName: self.entityName, into: self.moContext) as! MOType
        return chunkCoordMO
    }

    /// - Parameters:
    ///     - chunkCoord: chunk coordinate of chunk
    func load(at chunkCoord: ChunkCoordinate) -> [MOType] {
        let request = NSFetchRequest<MOType>(entityName: self.entityName)

        let chunkAddress = Int32(chunkCoord.address.value)
        let arguments: [Any] = [chunkCoord.x, chunkCoord.y, chunkAddress]
        request.predicate = NSPredicate(
            format: "x == %@ AND y == %@ AND address == %@",
            argumentArray: arguments)

        let chunkCoordMOs = try! self.moContext.fetch(request)
        return chunkCoordMOs
    }

}
