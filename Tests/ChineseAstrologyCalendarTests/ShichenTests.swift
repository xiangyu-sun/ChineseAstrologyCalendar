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
        let actualStart = Calendar.current.dateComponents([.hour, .minute ,.second], from: Dizhi.hai.startDate!)
        let expectedStart = DateComponents(calendar: Calendar.current, hour: 21, minute: 0, second: 0)
        XCTAssertEqual(actualStart.hour, expectedStart.hour)
        XCTAssertEqual(actualStart.minute, expectedStart.minute)
        XCTAssertEqual(actualStart.second, expectedStart.second)
        
        let actualEnd = Calendar.current.dateComponents([.hour, .minute ,.second], from: Dizhi.hai.endDate!)
        let expectedEnd = DateComponents(calendar: Calendar.current, hour: 22, minute: 59, second: 59)
        
        XCTAssertEqual(actualEnd.hour, expectedEnd.hour)
        XCTAssertEqual(actualEnd.minute, expectedEnd.minute)
        XCTAssertEqual(actualEnd.second, expectedEnd.second)
    }
    
    
    func testStartAndEndWithDayAndMonth() throws {
        let shichen = try! GanzhiDateConverter.shichen(Date(timeIntervalSince1970: 1665609080.5652242))
        
        let actualStart = Calendar.current.dateComponents([.month, .day, .hour, .minute ,.second], from: shichen.startDate!)
        let expectedStart = DateComponents(calendar: Calendar.current, month: 10, day: 12, hour: 23, minute: 0, second: 0)
        XCTAssertEqual(actualStart.hour, expectedStart.hour)
        XCTAssertEqual(actualStart.minute, expectedStart.minute)
        XCTAssertEqual(actualStart.second, expectedStart.second)
        XCTAssertEqual(actualStart.day, expectedStart.day)
        XCTAssertEqual(actualStart.month, expectedStart.month)
        
        let actualEnd = Calendar.current.dateComponents([.month, .day, .hour, .minute ,.second], from: shichen.endDate!)
        let expectedEnd = DateComponents(calendar: Calendar.current, month: 10, day: 13, hour: 0, minute: 59, second: 59)
        
        XCTAssertEqual(actualEnd.hour, expectedEnd.hour)
        XCTAssertEqual(actualEnd.minute, expectedEnd.minute)
        XCTAssertEqual(actualEnd.second, expectedEnd.second)
        XCTAssertEqual(actualEnd.day, expectedEnd.day)
        XCTAssertEqual(actualEnd.month, expectedEnd.month)
    }
    
}
