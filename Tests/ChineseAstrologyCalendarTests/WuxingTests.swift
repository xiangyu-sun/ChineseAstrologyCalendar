//
//  WuxingTests.swift
//  
//
//  Created by Xiangyu Sun on 9/12/22.
//

import XCTest
import ChineseAstrologyCalendar

final class WuxingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testKe() throws {
        //木克土，土克水，水克火，火克金，金克木
        XCTAssertEqual(Wuxing.mu.ke, .tu)
        XCTAssertEqual(Wuxing.tu.ke, .shui)
        XCTAssertEqual(Wuxing.shui.ke, .huo)
        XCTAssertEqual(Wuxing.huo.ke, .jin)
        XCTAssertEqual(Wuxing.jin.ke, .mu)
    }

}
