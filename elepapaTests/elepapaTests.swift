//
//  elepapaTests.swift
//  elepapaTests
//
//  Created by Yuming on 4/1/15.
//  Copyright (c) 2015 Yuming. All rights reserved.
//

import UIKit
import XCTest
// import elepapa

class elepapaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //func testParsesPapaId() {
    //    XCTAssertEqual(getPapaIdFromUrl(NSURL(string: "elepapa://11")!), 11)
    //    XCTAssertEqual(getPapaIdFromUrl(NSURL(string: "elepapa://noId")!), -1)
    //}
    //
    //func testGetsText() {
    //    var papa = PapaModel(id: 1, title: "testPapa", imageURL: "elepapa://11/a.jpg")
    //    papa.content = "<div>负分滚出</div>"
    //    XCTAssertEqual(papa.getText(), "负分滚出\n")
    //}
    //
    //func testGetsLongText() {
    //    var papa = PapaModel(id: 1, title: "testPapa", imageURL: "elepapa://11/a.jpg")
    //    papa.content = "<p>公交车上，一位年轻的父亲牵着大概5岁左右的小正太站着,<br>小正太：你怎么惹妈妈生气了？<br>父亲：别问了，你想晚上吃泡面吗?<br>小正太：不想<br>父亲：那就听爸的，到了姥姥家见到妈妈你就抱着她腿哭 你妈不跟我们回家 你就别松开...... <br>小正太：哦知道了， 爸 那你干嘛？<br>父亲犹豫片刻：我抱住另外一只哭 ...</p>"
    //    XCTAssertTrue(papa.getText().rangeOfString("公交车上") != nil)
    //    XCTAssertTrue(papa.getText().rangeOfString("<br>") == nil)
    //}
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}