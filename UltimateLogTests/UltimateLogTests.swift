//
//  UltimateLogTests.swift
//  UltimateLogTests
//
//  Created by Peigen.Liu on 1/14/19.
//  Copyright © 2019 Peigen.Liu. All rights reserved.
//

import XCTest
@testable import UltimateLog

class UltimateLogTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        Logger.setup(prefix: "TEST", filterLevel: .Verbose, encryptSeed: "TEST")
        
        Logger.v(tag: "TEST", msg: "This is VERBOSE")
        Logger.d(tag: "TEST", msg: "This is DEBUG")
        Logger.i(tag: "TEST", msg: "This is INFO")
        Logger.w(tag: "TEST", msg: "This is WARNING")
        Logger.e(tag: "TEST", msg: "This is ERROR")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
