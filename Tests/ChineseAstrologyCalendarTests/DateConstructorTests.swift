//
//  DateConstructorTests.swift
//  
//
//  Created by Xiangyu Sun on 24/12/22.
//

import XCTest

final class DateConstructorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConstuctor() throws {
        let date = try XCTUnwrap(DateComponents.getDate(year: 2023, month: 1, day: .chuyi))
        
        let components = date.dateComponentsFromCurrentCalendar

        XCTAssertEqual(components.year, 2023)
        XCTAssertEqual(components.month, 1)
        XCTAssertEqual(components.day, 22)
        XCTAssertEqual(components.hour, 0)
        XCTAssertEqual(components.minute, 0)
        XCTAssertEqual(components.second, 0)
    }


}
