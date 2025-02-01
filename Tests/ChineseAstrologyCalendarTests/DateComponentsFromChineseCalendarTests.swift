//
//  DateComponentsFromChineseCalendarTests.swift
//  ChineseAstrologyCalendar
//
//  Created by Xiangyu Sun on 1/2/25.
//


import XCTest

// If your project module is named, for example, "ChineseAstrologyCalendar", you may need to import it:
// @testable import ChineseAstrologyCalendar

class DateComponentsFromChineseCalendarTests: XCTestCase {
  
  /// Test conversion for a known Gregorian date.
  /// The expected Chinese date components are computed using a direct conversion via Calendar(identifier: .chinese).
  func testDateComponentsForKnownGregorianDate() {
    // Create a known Gregorian date: January 1, 2000 at 12:00:00 GMT.
    let gregorianCalendar = Calendar(identifier: .gregorian)
    var gregorianComponents = DateComponents()
    gregorianComponents.year = 2000
    gregorianComponents.month = 1
    gregorianComponents.day = 1
    gregorianComponents.hour = 12
    gregorianComponents.minute = 0
    gregorianComponents.second = 0
    gregorianComponents.timeZone = TimeZone(secondsFromGMT: 0)
    
    guard let date = gregorianCalendar.date(from: gregorianComponents) else {
      XCTFail("Failed to create date from Gregorian components")
      return
    }
    
    // Use our extension method to get Chinese calendar components.
    let resultComponents = date.dateComponentsFromChineseCalendar()
    
    // Compute expected components using a Calendar with .chinese identifier.
    let chineseCalendar = Calendar(identifier: .chinese)
    let expectedComponents = chineseCalendar.dateComponents([.year, .month, .day, .era], from: date)
    
    // Validate the Chinese date components.
    XCTAssertEqual(resultComponents.year, 1999, "Year component mismatch")
    XCTAssertEqual(resultComponents.month, expectedComponents.month, "Month component mismatch")
    XCTAssertEqual(resultComponents.day, expectedComponents.day, "Day component mismatch")
    XCTAssertEqual(resultComponents.era, expectedComponents.era, "Era component mismatch")
    
    // Also validate that the time components are carried over from the Gregorian date.
    let originalTimeComponents = gregorianCalendar.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
    XCTAssertEqual(resultComponents.hour, originalTimeComponents.hour, "Hour component mismatch")
    XCTAssertEqual(resultComponents.minute, originalTimeComponents.minute, "Minute component mismatch")
    XCTAssertEqual(resultComponents.second, originalTimeComponents.second, "Second component mismatch")
    XCTAssertEqual(resultComponents.nanosecond, originalTimeComponents.nanosecond, "Nanosecond component mismatch")
  }
  
  /// Test conversion when using a Chinese calendar with a custom time zone.
  func testDateComponentsWithCustomTimeZone() {
    // Create a Chinese calendar with GMT+8 (typical for mainland China)
    var customChineseCalendar = Calendar(identifier: .chinese)
    customChineseCalendar.timeZone = TimeZone(secondsFromGMT: 8 * 3600)!
    
    // Create a sample Gregorian date: July 3, 2020 at 15:45:30 GMT.
    let gregorianCalendar = Calendar(identifier: .gregorian)
    var dateComponents = DateComponents()
    dateComponents.year = 2020
    dateComponents.month = 7
    dateComponents.day = 3
    dateComponents.hour = 15
    dateComponents.minute = 45
    dateComponents.second = 30
    dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
    
    guard let date = gregorianCalendar.date(from: dateComponents) else {
      XCTFail("Failed to create date from Gregorian components")
      return
    }
    
    // Get Chinese calendar components using the custom calendar.
    let resultComponents = date.dateComponentsFromChineseCalendar(customChineseCalendar)
    
    // Compute expected Chinese components using the custom calendar directly.
    let expectedComponents = customChineseCalendar.dateComponents([.year, .month, .day, .era], from: date)
    XCTAssertEqual(resultComponents.year, 2020, "Year component mismatch with custom time zone")
    XCTAssertEqual(resultComponents.month, expectedComponents.month, "Month component mismatch with custom time zone")
    XCTAssertEqual(resultComponents.day, expectedComponents.day, "Day component mismatch with custom time zone")
    XCTAssertEqual(resultComponents.era, expectedComponents.era, "Era component mismatch with custom time zone")
  }
  
  /// Test conversion for a date at midnight.
  func testDateComponentsForDateAtMidnight() {
    // Create a Gregorian date for December 31, 2022 at midnight GMT.
    let gregorianCalendar = Calendar(identifier: .gregorian)
    var components = DateComponents()
    components.calendar = .current
    components.year = 2022
    components.month = 12
    components.day = 31
    components.hour = 0
    components.minute = 0
    components.second = 0
    components.timeZone = TimeZone(secondsFromGMT: 0)
    
    guard let date = gregorianCalendar.date(from: components) else {
      XCTFail("Failed to create midnight date")
      return
    }
    
    let resultComponents = date.dateComponentsFromChineseCalendar()
    
    // Validate that the time components are zero as expected.
    XCTAssertEqual(resultComponents.hour, 1, "Hour component should be 1 at midnight")
    XCTAssertEqual(resultComponents.minute, 0, "Minute component should be 0 at midnight")
    XCTAssertEqual(resultComponents.second, 0, "Second component should be 0 at midnight")
    
    // Ensure that the Chinese calendar date components are non-nil.
    XCTAssertNotNil(resultComponents.day, "Day component should not be nil")
    XCTAssertNotNil(resultComponents.month, "Month component should not be nil")
    XCTAssertNotNil(resultComponents.year, "Year component should not be nil")
    XCTAssertNotNil(resultComponents.era, "Era component should not be nil")
  }

}
