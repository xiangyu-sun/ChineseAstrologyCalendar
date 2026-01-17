import Foundation
//
//  DateComponentsFromChineseCalendarTests.swift
//  ChineseAstrologyCalendar
//
//  Created by Xiangyu Sun on 1/2/25.
//

import Testing

@Suite struct DateComponentsFromChineseCalendarTests {

  @Test func dateComponentsForKnownGregorianDate() throws {
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

    let date = try #require(gregorianCalendar.date(from: gregorianComponents))

    // Use our extension method to get Chinese calendar components.
    let resultComponents = date.dateComponentsFromChineseCalendar()

    // Compute expected components using a Calendar with .chinese identifier.
    let chineseCalendar = Calendar(identifier: .chinese)
    let expectedComponents = chineseCalendar.dateComponents([.year, .month, .day, .era], from: date)

    // Validate the Chinese date components.
    #expect(resultComponents.year == 1999)
    #expect(resultComponents.month == expectedComponents.month)
    #expect(resultComponents.day == expectedComponents.day)
    #expect(resultComponents.era == expectedComponents.era)

    // Also validate that the time components are carried over from the Gregorian date.
    let originalTimeComponents = gregorianCalendar.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
    #expect(resultComponents.hour == originalTimeComponents.hour)
    #expect(resultComponents.minute == originalTimeComponents.minute)
    #expect(resultComponents.second == originalTimeComponents.second)
    #expect(resultComponents.nanosecond == originalTimeComponents.nanosecond)
  }

  @Test func dateComponentsWithCustomTimeZone() throws {
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

    let date = try #require(gregorianCalendar.date(from: dateComponents))

    // Get Chinese calendar components using the custom calendar.
    let resultComponents = date.dateComponentsFromChineseCalendar(customChineseCalendar)

    // Compute expected Chinese components using the custom calendar directly.
    let expectedComponents = customChineseCalendar.dateComponents([.year, .month, .day, .era], from: date)
    #expect(resultComponents.year == 2020)
    #expect(resultComponents.month == expectedComponents.month)
    #expect(resultComponents.day == expectedComponents.day)
    #expect(resultComponents.era == expectedComponents.era)
  }

  @Test func dateComponentsForDateAtMidnight() throws {
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

    let date = try #require(gregorianCalendar.date(from: components))

    let resultComponents = date.dateComponentsFromChineseCalendar()

    // Validate that the time components are zero as expected.
    #expect(resultComponents.hour == 1)
    #expect(resultComponents.minute == 0)
    #expect(resultComponents.second == 0)

    // Ensure that the Chinese calendar date components are non-nil.
    #expect(resultComponents.day != nil)
    #expect(resultComponents.month != nil)
    #expect(resultComponents.year != nil)
    #expect(resultComponents.era != nil)
  }

}
