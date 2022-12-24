//
//  ShichenTests.swift
//
//
//  Created by Xiangyu Sun on 23/6/22.
//

import XCTest
@testable import ChineseAstrologyCalendar

final class ShichenTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testStartAndEnd() throws {
        let actualStart = Calendar.current.dateComponents([.hour, .minute ,.second], from:  Shichen(dizhi: Dizhi.hai, date: Date()).startDate)
        let expectedStart = DateComponents(calendar: Calendar.current, hour: 21, minute: 0, second: 0)
        XCTAssertEqual(actualStart.hour, expectedStart.hour)
        XCTAssertEqual(actualStart.minute, expectedStart.minute)
        XCTAssertEqual(actualStart.second, expectedStart.second)
        
        let actualEnd = Calendar.current.dateComponents([.hour, .minute ,.second], from: Shichen(dizhi: Dizhi.hai, date: Date()).endDate)
        let expectedEnd = DateComponents(calendar: Calendar.current, hour: 22, minute: 59, second: 59)
        
        XCTAssertEqual(actualEnd.hour, expectedEnd.hour)
        XCTAssertEqual(actualEnd.minute, expectedEnd.minute)
        XCTAssertEqual(actualEnd.second, expectedEnd.second)
    }
    
    func testStartAndEndWithDayAndMonth() throws {
        let shichen = try XCTUnwrap(Date(timeIntervalSince1970: 1665872877.2155929).shichen)
        XCTAssertEqual(shichen.dizhi, .zi)
        
        let actualStart = Calendar.current.dateComponents([.month, .day, .hour, .minute ,.second], from: shichen.startDate)
        let expectedStart = DateComponents(calendar: Calendar.current, month: actualStart.month!, day: actualStart.day, hour: 23, minute: 0, second: 0)
        
        XCTAssertEqual(actualStart.hour, expectedStart.hour)
        XCTAssertEqual(actualStart.minute, expectedStart.minute)
        XCTAssertEqual(actualStart.second, expectedStart.second)
        XCTAssertEqual(actualStart.day, expectedStart.day)
        XCTAssertEqual(actualStart.month, expectedStart.month)
        
        let actualEnd = Calendar.current.dateComponents([.month, .day, .hour, .minute ,.second], from: shichen.endDate)
        let expectedEnd = DateComponents(calendar: Calendar.current, month: actualEnd.month, day: actualEnd.day, hour: 0, minute: 59, second: 59)
        
        XCTAssertEqual(actualEnd.hour, expectedEnd.hour)
        XCTAssertEqual(actualEnd.minute, expectedEnd.minute)
        XCTAssertEqual(actualEnd.second, expectedEnd.second)
        XCTAssertEqual(actualEnd.day, expectedEnd.day)
        XCTAssertEqual(actualEnd.month, expectedEnd.month)
    }
    
    func testStartAndEndWithDayAndMonthBefore12() throws {
        let shichen = try XCTUnwrap(Date(timeIntervalSince1970: 1665869364.8679671).shichen)
        XCTAssertEqual(shichen.dizhi, .zi)
        
        let actualStart = Calendar.current.dateComponents([.month, .day, .hour, .minute ,.second], from: shichen.startDate)
        let expectedStart = DateComponents(calendar: Calendar.current, month: 10, day: 15, hour: 23, minute: 0, second: 0)
        
        XCTAssertEqual(actualStart.hour, expectedStart.hour)
        XCTAssertEqual(actualStart.minute, expectedStart.minute)
        XCTAssertEqual(actualStart.second, expectedStart.second)
        XCTAssertEqual(actualStart.day, expectedStart.day)
        XCTAssertEqual(actualStart.month, expectedStart.month)
        
        let actualEnd = Calendar.current.dateComponents([.month, .day, .hour, .minute ,.second], from: shichen.endDate)
        let expectedEnd = DateComponents(calendar: Calendar.current, month: 10, day: 16, hour: 0, minute: 59, second: 59)
        
        XCTAssertEqual(actualEnd.hour, expectedEnd.hour)
        XCTAssertEqual(actualEnd.minute, expectedEnd.minute)
        XCTAssertEqual(actualEnd.second, expectedEnd.second)
        XCTAssertEqual(actualEnd.day, expectedEnd.day)
        XCTAssertEqual(actualEnd.month, expectedEnd.month)
    }
    
}
