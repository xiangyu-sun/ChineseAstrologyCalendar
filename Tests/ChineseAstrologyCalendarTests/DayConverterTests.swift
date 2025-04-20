//
//  DayConverterTests.swift
//
//
//  Created by 孙翔宇 on 1/2/22.
//

import XCTest

@testable import ChineseAstrologyCalendar

class DayConverterTests: XCTestCase {
  let calendar = Calendar.current
  let testDate = DateComponents(calendar: Calendar.current, year: 2022, month: 1, day: 5, hour: 11, minute: 7)

  var dateConverter = DayConverter()
  let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.timeStyle = .none
    formatter.dateStyle = .short
    return formatter
  }()

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testOneDate() throws {
    let monthsHasSanshi = dateConverter.find(days: [.sanshi], inNextMonths: 12, from: calendar.date(from: testDate)!)
      .map { formatter.string(from: $0.date) }

    XCTAssertEqual(monthsHasSanshi, ["3/2/22", "4/30/22", "6/28/22", "7/28/22", "9/25/22", "11/23/22"])
  }

  func testTwoDate() throws {
    let monthsHasSanshi = dateConverter.find(days: [.chuyi, .shiwu], inNextMonths: 12, from: calendar.date(from: testDate)!)
      .map { formatter.string(from: $0.date) }

    XCTAssertEqual(
      monthsHasSanshi,
      [
        "1/17/22",
        "2/1/22",
        "2/15/22",
        "3/3/22",
        "3/17/22",
        "4/1/22",
        "4/15/22",
        "5/1/22",
        "5/15/22",
        "5/30/22",
        "6/13/22",
        "6/29/22",
        "7/13/22",
        "7/29/22",
        "8/12/22",
        "8/27/22",
        "9/10/22",
        "9/26/22",
        "10/10/22",
        "10/25/22",
        "11/8/22",
        "11/24/22",
        "12/8/22",
      ])
  }

  func testOneDateAndMonthEarlierThanNow() throws {
    let testDate = DateComponents(calendar: Calendar.current, year: 2022, month: 1, day: 16, hour: 6, minute: 7)

    let days = dateConverter.find(day: .chuba, month: .chou, inNextYears: 0, from: calendar.date(from: testDate)!)

    XCTAssertTrue(days.isEmpty)
  }

  func testOneDateAndMonthLaterThanNow() throws {
    let testDate = DateComponents(calendar: Calendar.current, year: 2022, month: 1, day: 16, hour: 6, minute: 7)

    let days = dateConverter.find(day: .erba, month: .chou, inNextYears: 0, from: calendar.date(from: testDate)!)
      .map { formatter.string(from: $0.date) }

    XCTAssertEqual(days, ["1/30/22"])
  }

  func testOneDateAndMonthFiveYearsLaterThanNow() throws {
    let testDate = DateComponents(calendar: Calendar.current, year: 2022, month: 1, day: 16, hour: 6, minute: 7)

    let days = dateConverter.find(day: .erba, month: .chou, inNextYears: 4, from: calendar.date(from: testDate)!)
      .map { formatter.string(from: $0.date) }

    XCTAssertEqual(days, ["1/30/22", "1/19/23", "2/7/24", "1/27/25", "2/15/26"])
  }

  func testNewYear() throws {
    let testDate = DateComponents(calendar: Calendar.current, year: 2022, month: 11, day: 2, hour: 0, minute: 0)

    let expectedDate = DateComponents(calendar: Calendar.current, year: 2023, month: 1, day: 22, hour: 0, minute: 0)

    let days = dateConverter.find(day: .chuyi, month: .yin, inNextYears: 1, from: calendar.date(from: testDate)!)
      .map(\.date)

    XCTAssertEqual(days, [calendar.date(from: expectedDate)!])
  }

  func testNewYearWithCST() throws {
    dateConverter = DayConverter(calendar: .chineseCalendarGTM8)

    let testDate = DateComponents(calendar: Calendar.current, year: 2022, month: 11, day: 2, hour: 0, minute: 0)

    let expectedDate = DateComponents(
      calendar: Calendar.chineseCalendarGTM8,
      year: 40,
      month: 1,
      day: 1,
      hour: 0,
      minute: 0)

    let days = dateConverter.find(day: .chuyi, month: .yin, inNextYears: 1, from: calendar.date(from: testDate)!)
      .map(\.date)

    XCTAssertEqual(days, [Calendar.chineseCalendarGTM8.date(from: expectedDate)!])
  }
}
