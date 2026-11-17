import Foundation
import Testing
@testable import ChineseAstrologyCalendar

/// Expected dates are China Standard Time calendar days, matching the
/// 24Jieqi app's SeasonalCounts tests and published almanacs (e.g. 三伏
/// 2023: 7/11, 7/21, 8/10; 2024: 7/15, 7/25, 8/14; 2025: 7/20, 7/30, 8/9).
@Suite struct SeasonalCountsTests {

  static func day(_ text: String) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = .chinaStandardTime
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(from: text)!
  }

  /// Noon on the given day, CST.
  static func noon(_ text: String) -> Date { day(text).addingTimeInterval(12 * 3600) }

  // MARK: 三伏

  @Test(arguments: [
    (2023, "2023-07-11", "2023-07-21", "2023-08-10", "2023-08-20"),
    (2024, "2024-07-15", "2024-07-25", "2024-08-14", "2024-08-24"),
    (2025, "2025-07-20", "2025-07-30", "2025-08-09", "2025-08-19"),
  ])
  func dogDaysOfKnownYears(_ year: Int, _ early: String, _ middle: String, _ late: String, _ end: String) {
    let fu = SeasonalCount.dogDays(inYear: year)
    #expect(fu == DogDays(early: Self.day(early), middle: Self.day(middle), late: Self.day(late), end: Self.day(end)))
  }

  @Test func dogDaysStartOnGengDays() {
    let calendar = transitCalendar(in: .chinaStandardTime)
    for year in 2000...2040 {
      let fu = SeasonalCount.dogDays(inYear: year)!
      for date in [fu.early, fu.middle, fu.late] {
        #expect(calendar.dateComponents([.year, .month, .day], from: date).riZhu?.gan == .geng)
      }
      let middleLength = calendar.dateComponents([.day], from: fu.middle, to: fu.late).day!
      #expect(middleLength == 10 || middleLength == 20)
    }
  }

  @Test func middleFuLastsTwentyDaysIn2024() {
    let count = SeasonalCount.dogDays(on: Self.noon("2024-07-25"))
    #expect(count?.period == 1)
    #expect(count?.day == 1)
    #expect(count?.periodLength == 20)
  }

  @Test func dogDaysOnDate() {
    let count = SeasonalCount.dogDays(on: Self.noon("2025-07-22"))
    #expect(count?.kind == .dogDays)
    #expect(count?.period == 0)
    #expect(count?.day == 3)
    #expect(count?.periodLength == 10)
    #expect(count?.start == Self.day("2025-07-20"))
    #expect(count?.end == Self.day("2025-08-19"))
    #expect(SeasonalCount.dogDays(on: Self.noon("2025-08-18"))?.period == 2)
    #expect(SeasonalCount.dogDays(on: Self.noon("2025-08-18"))?.day == 10)
    #expect(SeasonalCount.dogDays(on: Self.noon("2025-07-19")) == nil)
    #expect(SeasonalCount.dogDays(on: Self.noon("2025-08-19")) == nil)
  }

  // MARK: 梅雨

  @Test func plumRainsOfKnownYears() {
    #expect(SeasonalCount.plumRains(inYear: 2025) == PlumRains(start: Self.day("2025-06-06"), end: Self.day("2025-07-14")))
    #expect(SeasonalCount.plumRains(inYear: 2026) == PlumRains(start: Self.day("2026-06-11"), end: Self.day("2026-07-09")))
  }

  @Test func plumRainsOnDate() {
    let first = SeasonalCount.plumRains(on: Self.noon("2026-06-11"))
    #expect(first?.day == 1)
    #expect(first?.periodLength == 28)
    #expect(SeasonalCount.plumRains(on: Self.noon("2026-07-08"))?.day == 28)
    #expect(SeasonalCount.plumRains(on: Self.noon("2026-06-10")) == nil)
    #expect(SeasonalCount.plumRains(on: Self.noon("2026-07-09")) == nil)
  }

  @Test func plumRainsStartOnBingAndEndOnWei() {
    let calendar = transitCalendar(in: .chinaStandardTime)
    for year in 2000...2040 {
      let rains = SeasonalCount.plumRains(inYear: year)!
      #expect(calendar.dateComponents([.year, .month, .day], from: rains.start).riZhu?.gan == .bing)
      let last = calendar.date(byAdding: .day, value: -1, to: rains.end)!
      #expect(calendar.dateComponents([.year, .month, .day], from: last).riZhu?.zhi == .wei)
      #expect(rains.start < rains.end)
    }
  }

  // MARK: 數九

  @Test func ninesAroundTheSolstice() {
    // 冬至 2025 is 12-21 (CST).
    #expect(SeasonalCount.nines(on: Self.noon("2025-12-20")) == nil)
    let first = SeasonalCount.nines(on: Self.noon("2025-12-21"))
    #expect(first?.period == 0)
    #expect(first?.day == 1)
    #expect(first?.start == Self.day("2025-12-21"))
    #expect(first?.end == Self.day("2026-03-12"))
    // Early morning of the solstice day, before the 23:03 transit, still counts.
    #expect(SeasonalCount.nines(on: Self.day("2025-12-21").addingTimeInterval(60))?.day == 1)

    let third = SeasonalCount.nines(on: Self.noon("2026-01-08"))
    #expect(third?.period == 2)
    #expect(third?.day == 1)
    let last = SeasonalCount.nines(on: Self.noon("2026-03-11"))
    #expect(last?.period == 8)
    #expect(last?.day == 9)
    #expect(SeasonalCount.nines(on: Self.noon("2026-03-12")) == nil)
  }

  @Test func activeCounts() {
    #expect(SeasonalCount.active(on: Self.noon("2026-01-08")).map(\.kind) == [.nines])
    #expect(SeasonalCount.active(on: Self.noon("2025-07-10")).map(\.kind) == [.plumRains])
    #expect(SeasonalCount.active(on: Self.noon("2025-07-22")).map(\.kind) == [.dogDays])
    #expect(SeasonalCount.active(on: Self.noon("2025-10-01")).isEmpty)
  }

  @Test func timeZoneShiftsTheDay() {
    // 冬至 2025 is 2025-12-21 15:03 UTC (10:03 in New York). Noon CST on
    // 12-21 is still 12-20 in New York, so the count has not begun there.
    let newYork = TimeZone(identifier: "America/New_York")!
    #expect(SeasonalCount.nines(on: Self.noon("2025-12-21"), timeZone: newYork) == nil)
    let afternoonInNewYork = Self.day("2025-12-22").addingTimeInterval(2 * 3600)  // 13:00 EST 12-21
    #expect(SeasonalCount.nines(on: afternoonInNewYork, timeZone: newYork)?.day == 1)
    #expect(SeasonalCount.nines(on: afternoonInNewYork)?.day == 2)
    let fu = SeasonalCount.dogDays(inYear: 2025, timeZone: newYork)!
    let calendar = transitCalendar(in: newYork)
    #expect(calendar.dateComponents([.year, .month, .day], from: fu.early).riZhu?.gan == .geng)
  }

  // MARK: Names

  @Test func names() {
    #expect(SeasonalCount.Kind.nines.localizedName(in: .zhHant) == "數九")
    #expect(SeasonalCount.Kind.nines.localizedName(in: .zhHans) == "数九")
    #expect(SeasonalCount.Kind.dogDays.localizedName(in: .en) == "Dog Days")
    #expect(SeasonalCount.Period(kind: .nines, index: 2).localizedName(in: .zhHant) == "三九")
    #expect(SeasonalCount.Period(kind: .nines, index: 2).localizedName(in: .en) == "Third Nine")
    #expect(SeasonalCount.Period(kind: .dogDays, index: 1).localizedName(in: .zhHans) == "中伏")
    #expect(SeasonalCount.Period(kind: .dogDays, index: 2).localizedName(in: .en) == "Late Fu")
    #expect(SeasonalCount.dogDays(on: Self.noon("2025-07-31"))?.localizedName(in: .zhHant) == "中伏")
  }

  @Test(arguments: DisplayLanguage.allCases)
  func everyNameIsNonEmpty(_ language: DisplayLanguage) {
    for kind in SeasonalCount.Kind.allCases {
      #expect(!kind.localizedName(in: language).isEmpty)
      for index in 0..<kind.periodCount {
        #expect(!SeasonalCount.Period(kind: kind, index: index).localizedName(in: language).isEmpty)
      }
    }
  }
}
