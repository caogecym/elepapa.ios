//
//  elepapaTests.swift
//  elepapaTests
//
//  Created by Yuming on 4/1/15.
//  Copyright (c) 2015 Yuming. All rights reserved.
//

import UIKit
import XCTest

class elepapaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParsesPapaId() {
        //XCTAssertEqual(getPapaIdFromUrl(NSURL(string: "elepapa://11")!), 11)
        //XCTAssertEqual(getPapaIdFromUrl(NSURL(string: "elepapa://noId")!), -1)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
