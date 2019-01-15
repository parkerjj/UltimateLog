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
        
        UltimateLog.setup(prefix: "TEST", filterLevel: .Verbose, encryptSeed: "TEST")
        
        UltimateLog.v(tag: "TEST", msg: "This is VERBOSE")
        UltimateLog.d(tag: "TEST", msg: "This is DEBUG")
        UltimateLog.i(tag: "TEST", msg: "This is INFO")
        UltimateLog.w(tag: "TEST", msg: "This is WARNING")
        UltimateLog.e(tag: "TEST", msg: "This is ERROR")
        
        
        
        let path = UltimateLog.zipLog()
        UltimateLog.v(msg: path ?? "")
        

    }
    
    
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
