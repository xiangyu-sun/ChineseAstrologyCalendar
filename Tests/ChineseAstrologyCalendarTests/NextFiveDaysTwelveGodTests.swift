//
//  NextFiveDaysTwelveGodTests.swift
//  ChineseAstrologyCalendar
//
//  Created by Xiangyu Sun on 24/6/25.
//

import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct NextFiveDaysTwelveGodTests {

  @Test func twelveGodsForNextFiveDays() {
    let df = DateFormatter()
    df.calendar = Calendar(identifier: .gregorian)
    df.dateFormat = "yyyy-MM-dd"

    // 2025-06-24 → 破
    let date1 = df.date(from: "2025-06-24")!
    #expect(date1.twelveGod() == .destruction, "2025-06-24 should be 破")

    // 2025-06-25 → 危
    let date2 = df.date(from: "2025-06-25")!
    #expect(date2.twelveGod() == .danger, "2025-06-25 should be 危")

    // 2025-06-26 → 成
    let date3 = df.date(from: "2025-06-26")!
    #expect(date3.twelveGod() == .completion, "2025-06-26 should be 成")

    // 2025-06-27 → 收
    let date4 = df.date(from: "2025-06-27")!
    #expect(date4.twelveGod() == .harvest, "2025-06-27 should be 收")

    // 2025-06-28 → 開
    let date5 = df.date(from: "2025-06-28")!
    #expect(date5.twelveGod() == .opening, "2025-06-28 should be 開")
  }


  @Test func twelveGodsForNextFiveDays_july() {
    let df = DateFormatter()
    df.calendar = Calendar(identifier: .gregorian)
    df.dateFormat = "yyyy-MM-dd"


    let date1 = df.date(from: "2025-07-01")!
    #expect(date1.twelveGod() == .remove)


    let date2 = df.date(from: "2025-07-02")!
    #expect(date2.twelveGod() == .fullness)


    let date3 = df.date(from: "2025-07-03")!
    #expect(date3.twelveGod() == .balance)


    let date4 = df.date(from: "2025-07-04")!
    #expect(date4.twelveGod() == .stability)


    let date5 = df.date(from: "2025-07-05")!
    #expect(date5.twelveGod() == .grasp)
  }
}
