//
//  tiny_homeTests.swift
//  tiny_homeTests
//
//  Created by 박정훈 on 2023/06/21.
//

import XCTest
@testable import a_month_game

final class tiny_homeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let chunkCoord1 = ChunkCoordinate(-1, 0)
        let chunkCoord2 = ChunkCoordinate(-1, 1)
        print(chunkCoord1)
        print(chunkCoord2)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
