import Foundation
import Testing
@testable import ChineseAstrologyCalendar

// MARK: - ChineseFestivalTests

@Suite struct ChineseFestivalTests {

  // MARK: - Lunar date properties

  @Test func springFestivalIsFirstMonthFirstDay() {
    #expect(ChineseFestival.springFestival.lunarMonth == 1)
    #expect(ChineseFestival.springFestival.lunarDay == 1)
  }

  @Test func midAutumnIsFifthDayEighthMonth() {
    #expect(ChineseFestival.midAutumn.lunarMonth == 8)
    #expect(ChineseFestival.midAutumn.lunarDay == 15)
  }

  @Test func dragonBoatIsFifthMonthFifthDay() {
    #expect(ChineseFestival.dragonBoat.lunarMonth == 5)
    #expect(ChineseFestival.dragonBoat.lunarDay == 5)
  }

  @Test func lanternFestivalIsFirstMonthFifteenth() {
    #expect(ChineseFestival.lanternFestival.lunarMonth == 1)
    #expect(ChineseFestival.lanternFestival.lunarDay == 15)
  }

  @Test func labaIsTwelfthMonthEighthDay() {
    #expect(ChineseFestival.laba.lunarMonth == 12)
    #expect(ChineseFestival.laba.lunarDay == 8)
  }

  // MARK: - Solar term festivals have nil lunar dates

  @Test func qingmingHasNilLunarDate() {
    #expect(ChineseFestival.qingming.lunarMonth == nil)
    #expect(ChineseFestival.qingming.lunarDay == nil)
    #expect(ChineseFestival.qingming.jieqi == .clearAndBright)
  }

  @Test func dongzhiHasNilLunarDate() {
    #expect(ChineseFestival.dongzhi.lunarMonth == nil)
    #expect(ChineseFestival.dongzhi.lunarDay == nil)
    #expect(ChineseFestival.dongzhi.jieqi == .winterSolstice)
  }

  // MARK: - Chinese names

  @Test func chineseNamesAreNonEmpty() {
    for festival in ChineseFestival.allCases {
      #expect(!festival.chineseName.isEmpty, "\(festival) should have a non-empty Chinese name")
    }
  }

  @Test func knownChineseNames() {
    #expect(ChineseFestival.springFestival.chineseName == "春節")
    #expect(ChineseFestival.midAutumn.chineseName == "中秋節")
    #expect(ChineseFestival.dragonBoat.chineseName == "端午節")
    #expect(ChineseFestival.dongzhi.chineseName == "冬至")
  }

  // MARK: - All cases completeness

  @Test func allCasesCountIsCorrect() {
    #expect(ChineseFestival.allCases.count == 12)
  }

  @Test func meaningIsNonEmpty() {
    for festival in ChineseFestival.allCases {
      #expect(!festival.meaning.isEmpty)
    }
  }

  // MARK: - Next date finding

  @Test func springFestivalNextDateIsInFuture() {
    let converter = DayConverter()
    let now = Date()
    let next = ChineseFestival.springFestival.nextDate(from: now, converter: converter)
    if let nextDate = next {
      #expect(nextDate >= now)
    }
  }

  @Test func midAutumnNextDateIsInFuture() {
    let converter = DayConverter()
    let now = Date()
    let next = ChineseFestival.midAutumn.nextDate(from: now, converter: converter)
    if let nextDate = next {
      #expect(nextDate >= now)
    }
  }

  // MARK: - Known festival dates

  /// Spring Festival 2025 is January 29, 2025 (Gregorian, CST UTC+8).
  @Test func springFestival2025() {
    // Use CST (UTC+8) — the Chinese calendar operates in this timezone.
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(identifier: "Asia/Shanghai")!
    let start = cal.date(from: DateComponents(year: 2025, month: 1, day: 1))!
    let converter = DayConverter()
    let next = ChineseFestival.springFestival.nextDate(from: start, converter: converter)
    guard let nextDate = next else {
      #expect(Bool(false), "Spring Festival 2025 should be found")
      return
    }
    let components = cal.dateComponents([.year, .month, .day], from: nextDate)
    #expect(components.year == 2025)
    #expect(components.month == 1)
    #expect(components.day == 29)
  }

  /// Mid-Autumn Festival 2025 is October 6, 2025 (Gregorian, CST UTC+8).
  @Test func midAutumnFestival2025() {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(identifier: "Asia/Shanghai")!
    let start = cal.date(from: DateComponents(year: 2025, month: 9, day: 1))!
    let converter = DayConverter()
    let next = ChineseFestival.midAutumn.nextDate(from: start, converter: converter)
    guard let nextDate = next else {
      #expect(Bool(false), "Mid-Autumn 2025 should be found")
      return
    }
    let components = cal.dateComponents([.year, .month, .day], from: nextDate)
    #expect(components.year == 2025)
    #expect(components.month == 10)
    #expect(components.day == 6)
  }

  /// Dragon Boat Festival 2025 is May 31, 2025 (Gregorian, CST UTC+8).
  @Test func dragonBoatFestival2025() {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(identifier: "Asia/Shanghai")!
    let start = cal.date(from: DateComponents(year: 2025, month: 5, day: 1))!
    let converter = DayConverter()
    let next = ChineseFestival.dragonBoat.nextDate(from: start, converter: converter)
    guard let nextDate = next else {
      #expect(Bool(false), "Dragon Boat 2025 should be found")
      return
    }
    let components = cal.dateComponents([.year, .month, .day], from: nextDate)
    #expect(components.year == 2025)
    #expect(components.month == 5)
    #expect(components.day == 31)
  }
}
