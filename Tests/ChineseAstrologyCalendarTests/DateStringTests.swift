//
//  DateStringTests.swift
//  
//
//  Created by Xiangyu Sun on 23/6/22.
//

import XCTest
@testable import ChineseAstrologyCalendar

final class DateStringTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_chineseYearMonthDate() throws {
        let compoenent = DateComponents(calendar: .current, year: 2022, month: 6, day: 7, hour: 17)
        
        let date = Calendar.current.date(from: compoenent)
        
        XCTAssertEqual(date?.chineseYearMonthDate, "壬寅年五月初九")
    }
    
    func test_chineseYearMonthDateZodia() throws {
        let compoenent = DateComponents(calendar: .current, year: 2022, month: 6, day: 7, hour: 17)
        
        let date = Calendar.current.date(from: compoenent)
        
        XCTAssertEqual(date?.displayStringOfChineseYearMonthDateWithZodiac, "壬寅虎年五月初九")
    }
    
    func test_chineseMonth() throws {
        let compoenent = DateComponents(calendar: .current, year: 2022, month: 6, day: 7, hour: 17)
        
        let date = Calendar.current.date(from: compoenent)
        let dizhi = try GanzhiDateConverter.shichen(date!)
        XCTAssertEqual(dizhi.formattedMonth, "五月")
    }
    
    func test_chineseMonthandDate() throws {
        let compoenent = DateComponents(calendar: .current, year: 2022, month: 11, day: 1, hour: 17)
        
        let date = Calendar.current.date(from: compoenent)
        XCTAssertEqual( date!.chineseMonthAndDate, "初八")
    }
    
}
