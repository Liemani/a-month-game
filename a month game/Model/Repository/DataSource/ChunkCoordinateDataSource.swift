//
//  ChunkCoordinateRepository.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/17.
//

import Foundation
import CoreData

class ChunkCoordinateDataSource {

    private let moContext: NSManagedObjectContext

    init(_ moContext: NSManagedObjectContext) {
        self.moContext = moContext
    }

    func new() -> ChunkCoordinateMO {
        let entityName = Constant.Name.chunkCoordinateEntity
        let chunkCoordMO = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.moContext) as! ChunkCoordinateMO
        return chunkCoordMO
    }

    func load(at chunkCoord: ChunkCoordinate) -> [ChunkCoordinateMO] {
        let request = NSFetchRequest<ChunkCoordinateMO>(entityName: Constant.Name.chunkCoordinateEntity)

        let chunkAddress = UInt32(chunkCoord.address.chunk.value) << 8
        let nextChunkAdress = chunkAddress + 0x0100
        let arguments: [Any] = [chunkCoord.x, chunkCoord.y, chunkAddress, nextChunkAdress]
        request.predicate = NSPredicate(format: "x == %@ AND y == %@ AND %@ <= location AND location < %@", argumentArray: arguments)

        let chunkCoordMOs = try! self.moContext.fetch(request)
        return chunkCoordMOs
    }

}

extension ChunkCoordinateMO {

    func update(_ chunkCoord: ChunkCoordinate) {
        self.x = chunkCoord.x
        self.y = chunkCoord.y
        self.location = Int32(chunkCoord.address.value)
    }

    func delete() {
        Services.default.moContext.delete(self)
    }

}
