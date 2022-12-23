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
    let component = DateComponents(calendar: .current, year: 2022, month: 6, day: 7, hour: 17)

    let date = Calendar.current.date(from: component)

    XCTAssertEqual(date?.chineseYearMonthDate, "壬寅年五月初九")
  }

  func test_chineseYearMonthDateZodia() throws {
    let component = DateComponents(calendar: .current, year: 2022, month: 6, day: 7, hour: 17)

    let date = Calendar.current.date(from: component)

    XCTAssertEqual(date?.displayStringOfChineseYearMonthDateWithZodiac, "壬寅虎年五月初九")
  }

  func test_chineseMonth() throws {

      let dizhi = Dizhi.you
      
      let component2 = DateComponents(calendar: .current, year: 2022, month: 8, day: 10, hour: 17)

      let date2 = Calendar.current.date(from: component2)
      
    XCTAssertEqual(dizhi.formattedMonth, Dizhi.monthFormatter.string(from: date2!))
  }

  func test_chineseMonthandDate() throws {
    let component = DateComponents(calendar: .current, year: 2022, month: 11, day: 1, hour: 17)

    let date = Calendar.current.date(from: component)
    XCTAssertEqual(date!.chineseYearMonthDate, "壬寅年十月初八")
  }

}
