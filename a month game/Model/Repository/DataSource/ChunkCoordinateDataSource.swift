//
//  ChunkCoordinateRepository.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/17.
//

import Foundation
import CoreData

class ChunkCoordinateDataSource {

    private let persistentContainer: LMIPersistentContainer

    init(_ persistentContainer: LMIPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    private var moContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    // MARK: - edit
    func new() -> ChunkCoordinateMO {
        let entityName = Constant.Name.chunkCoordinateEntity
        let chunkCoordMO = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.moContext) as! ChunkCoordinateMO
        return chunkCoordMO
    }

    func load(at coord: ChunkCoordinate) -> [ChunkCoordinateMO] {
        let request = NSFetchRequest<ChunkCoordinateMO>(entityName: Constant.Name.chunkCoordinateEntity)
        let chunkLocation = UInt32(bitPattern: Int32(coord.location)) & 0xff00
        let nextChunkLocation = chunkLocation + 0x0100
        let arguments: [Any] = [coord.x, coord.y, chunkLocation, nextChunkLocation]
        request.predicate = NSPredicate(format: "x == %@ AND y == %@ AND %@ <= location AND location < %@", argumentArray: arguments)

        let chunkCoordMOs = try! self.moContext.fetch(request)
        return chunkCoordMOs
    }

    func delete(_ chunkCoordMO: ChunkCoordinateMO) {
        self.moContext.delete(chunkCoordMO)
    }

    func contextSave() {
        try! self.moContext.save()
    }

}

extension ChunkCoordinateMO {

    func update(_ chunkCoord: ChunkCoordinate) {
        self.x = chunkCoord.x
        self.y = chunkCoord.y
        self.location = chunkCoord.location
    }

}
