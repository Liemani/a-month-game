//
//  MapGenerator.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/15.
//

import Foundation
import GameplayKit

class MapGenerator {

    private static var _default: MapGenerator?
    static var `default`: MapGenerator { self._default! }

    static func set() {
        self._default = MapGenerator()
    }

    static func free() { self._default = nil }

    var regionChunkCoord: ChunkCoordinate!
    var regionNoiseMap: GKNoiseMap!

    func generateChunk(_ chunkChunkCoord: ChunkCoordinate) -> [GameObjectMO] {
        let chunkSide = Constant.tileCountOfChunkSide

        if let regionChunkCoord = self.regionChunkCoord {
            if chunkChunkCoord.x != self.regionChunkCoord.x
                || chunkChunkCoord.y != regionChunkCoord.y {
                var regionChunkCoord = chunkChunkCoord
                regionChunkCoord.address.chunk.setZero()

                self.regionChunkCoord = regionChunkCoord
                self.regionNoiseMap = self.generateRegionNoiseMap(
                    chunkCoord: regionChunkCoord)
            }
        } else {
            var regionChunkCoord = chunkChunkCoord
            regionChunkCoord.address.chunk.setZero()

            self.regionChunkCoord = regionChunkCoord
            self.regionNoiseMap = self.generateRegionNoiseMap(
                chunkCoord: regionChunkCoord)
        }

        var tileChunkCoord = chunkChunkCoord

        var mos: [GameObjectMO] = []

        Services.default.chunkIsGeneratedRepo.new(chunkCoord: chunkChunkCoord)

        for y in 0 ..< chunkSide {
            tileChunkCoord.address.tile.rawCoord.y = UInt8(y)

            for x in 0 ..< chunkSide {
                tileChunkCoord.address.tile.rawCoord.x = UInt8(x)

                let regionX = tileChunkCoord.address.coordX
                let regionY = tileChunkCoord.address.coordY
                let location = vector2(Int32(regionX), Int32(regionY))
                let altitude = (self.baseRegionMapValue(x: regionX, y: regionY)
                                + self.regionNoiseMap.value(at: location)) / 2.0

//                let altitude = self.regionNoiseMap.value(at: location)

                let goType = self.goType(by: altitude)

                if goType != .none {
                    let mo = Services.default.goServ.newMO(type: goType,
                                                           coord: tileChunkCoord)

                    mos.append(mo)
                }
            }
        }

        return mos
    }

    func goType(by altitude: Float) -> GameObjectType {
        let seaLevel = ClosedRange<Float>(uncheckedBounds: (-1.0, 0.0))
        let sandLevel = Range<Float>(uncheckedBounds: (0.0, 0.15))
        let cobbleStoneLevel = Range<Float>(uncheckedBounds: (0.15, 0.20))
        let weedLevel = Range<Float>(uncheckedBounds: (0.6, 0.8))
        let vineLevel = Range<Float>(uncheckedBounds: (0.8, 0.9))
        let oakTreeLevel = Range<Float>(uncheckedBounds: (0.9, 1.0))

        var goType: GameObjectType = .none

        if seaLevel ~= altitude {
            goType = .waterTile
        } else if sandLevel ~= altitude {
            goType = .sandTile
        } else if cobbleStoneLevel ~= altitude {
            goType = .cobblestoneTile
        } else if weedLevel ~= altitude {
            if (arc4random() & 0x3) == 0 {
                goType = .weed
            }
        } else if vineLevel ~= altitude {
            if (arc4random() & 0x7) == 0 {
                goType = .vine
            }
        } else if oakTreeLevel ~= altitude {
            if (arc4random() & 0x3) == 0 {
                goType = .treeOak
            }
        }

        return goType
    }

    func baseRegionMapValue(x: Int, y: Int) -> Float {
        let halfSide = Constant.tileCountOfRegionSide >> 1
        let landBound: Float = 0.0

        let absX = abs(x - halfSide)
        let absY = abs(y - halfSide)

        //  ratio: [-1.0, 1.0]
        let ratio = 1.0 - Float(max(absX, absY)) / Float(halfSide >> 1)

        let landAltitude = ratio - landBound
        let seaIncline = (landBound - 1.0) / 2.0

        if landAltitude > 0.0 {
            return 1.0
        }

        return 1.0 - landAltitude / seaIncline
    }

//    func generateChunkNoiseMap(chunkCoord: ChunkCoordinate) -> GKNoiseMap {
//        let tileCountOfChunkSide = Constant.tileCountOfChunkSide
//
//        let sampleCount = vector2(Int32(tileCountOfChunkSide),
//                                  Int32(tileCountOfChunkSide))
//
//        let worldSeed: Int32 = 0
//        let regionSeed = Int32(chunkCoord.x << 16 + chunkCoord.y + worldSeed)
//
//        return self.generateNoiseMap(sampleCount: sampleCount,
//                                     seed: regionSeed)
//    }

    /// - Parameters:
    ///         - chunkCoord: the chunk coord of region
    ///
    func generateRegionNoiseMap(chunkCoord: ChunkCoordinate) -> GKNoiseMap {
        let worldSeed = 0
        let regionSeed = Int32(truncatingIfNeeded:
                                Int(chunkCoord.x) << 8
                               + Int(chunkCoord.y)
                               + worldSeed)

        let tileCountOfRegionSide = Constant.tileCountOfRegionSide

        let sampleCount = vector2(Int32(tileCountOfRegionSide),
                                  Int32(tileCountOfRegionSide))

        return self.generateNoiseMap(sampleCount: sampleCount,
                                     seed: regionSeed)
    }

    func generateNoiseMap(sampleCount: vector_int2,
                          seed: Int32) -> GKNoiseMap {
        // hidden mechanism: 'seed + (0x1 << 16) * N' output same pelin noise source lol
        let source = GKPerlinNoiseSource(frequency: 2.0,
                                         octaveCount: 6,
                                         persistence: 0.5,
                                         lacunarity: 2.0,
                                         seed: seed)

        return GKNoiseMap(GKNoise(source),
                          size: vector2(1.0, 1.0),
                          origin: vector2(0.0, 0.0),
                          sampleCount: sampleCount,
                          seamless: false)
    }

}
