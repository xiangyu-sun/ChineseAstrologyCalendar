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

  @Test func startAndEndWithDayAndMonth() throws {
    let shichen = try #require(Date(timeIntervalSince1970: 1665872877.2155929).shichen)
    #expect(shichen.dizhi == .zi)

    let actualStart = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: shichen.startDate)
    let expectedStart = DateComponents(
      calendar: Calendar.current,
      month: actualStart.month!,
      day: actualStart.day,
      hour: 23,
      minute: 0,
      second: 0)

    #expect(actualStart.hour == expectedStart.hour)
    #expect(actualStart.minute == expectedStart.minute)
    #expect(actualStart.second == expectedStart.second)
    #expect(actualStart.day == expectedStart.day)
    #expect(actualStart.month == expectedStart.month)

    let actualEnd = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: shichen.endDate)
    let expectedEnd = DateComponents(
      calendar: Calendar.current,
      month: actualEnd.month,
      day: actualEnd.day,
      hour: 1,
      minute: 0,
      second: 0)

    #expect(actualEnd.hour == expectedEnd.hour)
    #expect(actualEnd.minute == expectedEnd.minute)
    #expect(actualEnd.second == expectedEnd.second)
    #expect(actualEnd.day == expectedEnd.day)
    #expect(actualEnd.month == expectedEnd.month)
  }

  @Test func startAndEndWithDayAndMonthBefore12() throws {
    let shichen = try #require(Date(timeIntervalSince1970: 1665869364.8679671).shichen)
    #expect(shichen.dizhi == .zi)

    let actualStart = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: shichen.startDate)
    let expectedStart = DateComponents(calendar: Calendar.current, month: 10, day: 15, hour: 23, minute: 0, second: 0)

    #expect(actualStart.hour == expectedStart.hour)
    #expect(actualStart.minute == expectedStart.minute)
    #expect(actualStart.second == expectedStart.second)
    #expect(actualStart.day == expectedStart.day)
    #expect(actualStart.month == expectedStart.month)

    let actualEnd = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: shichen.endDate)
    let expectedEnd = DateComponents(calendar: Calendar.current, month: 10, day: 16, hour: 1, minute: 0, second: 0)

    #expect(actualEnd.hour == expectedEnd.hour)
    #expect(actualEnd.minute == expectedEnd.minute)
    #expect(actualEnd.second == expectedEnd.second)
    #expect(actualEnd.day == expectedEnd.day)
    #expect(actualEnd.month == expectedEnd.month)
  }

}
