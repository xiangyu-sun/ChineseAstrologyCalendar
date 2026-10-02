//
//  ShichenTests.swift
//
//
//  Created by Xiangyu Sun on 23/6/22.
//

import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct ShichenTests {

  @Test func startAndEnd() throws {
    let actualStart = Calendar.current.dateComponents(
      [.hour, .minute, .second],
      from: Shichen(dizhi: Dizhi.hai, date: Date()).startDate)
    let expectedStart = DateComponents(calendar: Calendar.current, hour: 21, minute: 0, second: 0)
    #expect(actualStart.hour == expectedStart.hour)
    #expect(actualStart.minute == expectedStart.minute)
    #expect(actualStart.second == expectedStart.second)

    let actualEnd = Calendar.current.dateComponents(
      [.hour, .minute, .second],
      from: Shichen(dizhi: Dizhi.hai, date: Date()).endDate)
    let expectedEnd = DateComponents(calendar: Calendar.current, hour:23, minute: 0, second: 0)

    #expect(actualEnd.hour == expectedEnd.hour)
    #expect(actualEnd.minute == expectedEnd.minute)
    #expect(actualEnd.second == expectedEnd.second)
  }

  /// Reference date inside 子時 *after* midnight, so the period's start rolls
  /// back to 23:00 of the previous day. Pinned to China Standard Time (UTC+8)
  /// so the assertions are independent of the host machine's time zone.
  @Test func startAndEndWithDayAndMonth() throws {
    let timeZone = TimeZone(secondsFromGMT: 8 * 3600)!
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = timeZone

    // 00:30 CST — inside 子時 (23:00–01:00), just after midnight.
    let date = try #require(
      calendar.date(from: DateComponents(year: 2022, month: 10, day: 16, hour: 0, minute: 30)))
    let hour = try #require(calendar.dateComponents([.hour], from: date).hour)
    let shichen = Shichen(dizhi: Dizhi(hourOfDay: hour), date: date, calendar: calendar, timeZone: timeZone)
    #expect(shichen.dizhi == .zi)

    let actualStart = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: shichen.startDate)
    #expect(actualStart.month == 10)
    #expect(actualStart.day == 15)
    #expect(actualStart.hour == 23)
    #expect(actualStart.minute == 0)
    #expect(actualStart.second == 0)

    let actualEnd = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: shichen.endDate)
    #expect(actualEnd.month == 10)
    #expect(actualEnd.day == 16)
    #expect(actualEnd.hour == 1)
    #expect(actualEnd.minute == 0)
    #expect(actualEnd.second == 0)
  }

  /// Reference date inside 子時 *before* midnight, so the period's end rolls
  /// forward to 01:00 of the next day. Pinned to China Standard Time (UTC+8).
  @Test func startAndEndWithDayAndMonthBefore12() throws {
    let timeZone = TimeZone(secondsFromGMT: 8 * 3600)!
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = timeZone

    // 23:30 CST — inside 子時, before midnight.
    let date = try #require(
      calendar.date(from: DateComponents(year: 2022, month: 10, day: 15, hour: 23, minute: 30)))
    let hour = try #require(calendar.dateComponents([.hour], from: date).hour)
    let shichen = Shichen(dizhi: Dizhi(hourOfDay: hour), date: date, calendar: calendar, timeZone: timeZone)
    #expect(shichen.dizhi == .zi)

    let actualStart = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: shichen.startDate)
    #expect(actualStart.month == 10)
    #expect(actualStart.day == 15)
    #expect(actualStart.hour == 23)
    #expect(actualStart.minute == 0)
    #expect(actualStart.second == 0)

    let actualEnd = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: shichen.endDate)
    #expect(actualEnd.month == 10)
    #expect(actualEnd.day == 16)
    #expect(actualEnd.hour == 1)
    #expect(actualEnd.minute == 0)
    #expect(actualEnd.second == 0)
  }

}
