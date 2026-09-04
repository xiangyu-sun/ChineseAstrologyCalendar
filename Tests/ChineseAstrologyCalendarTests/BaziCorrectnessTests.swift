import Foundation
import Testing
@testable import ChineseAstrologyCalendar

/// Regression tests for the Bazi pillar bugs found by audit:
///   - `shiGan` used the day's own branch instead of the hour's branch, making
///     the hour stem constant across all 12 shichen of a day.
///   - `Bazi.init(date:)` fed Apple's cyclic Chinese-calendar year (1...60) into
///     a formula written for the Gregorian year, corrupting 年柱/月柱.
///   - `YearGanzhi.nianZhi` traps on negative-modulo array indexing for years
///     more than 2697 BCE.
@Suite struct BaziCorrectnessTests {

  /// Every valid 干支 pairs a stem and branch of the same parity — this is a
  /// structural invariant of the 60-jiazi cycle, independent of any reference
  /// data. It fails immediately on the constant-hour-stem bug (e.g. 癸寅).
  @Test func ganzhiParityInvariantAcrossManyDates() throws {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(secondsFromGMT: 8 * 3600)!

    var violations: [String] = []
    for year in stride(from: 1950, through: 2050, by: 1) {
      for (month, day, hour) in [(1, 15, 3), (4, 12, 9), (6, 9, 12), (9, 23, 17), (12, 21, 23)] {
        let components = DateComponents(year: year, month: month, day: day, hour: hour)
        guard let date = cal.date(from: components), let bazi = Bazi(date: date) else { continue }
        for pillar in bazi.pillars where pillar.gan.rawValue % 2 != pillar.zhi.rawValue % 2 {
          violations.append("\(year)-\(month)-\(day) \(hour)h: \(pillar.description)")
        }
      }
    }
    #expect(violations.isEmpty, "Parity violations: \(violations)")
  }

  /// The hour *stem* (時干) must vary across the 12 shichen of a day — only the
  /// branch repeats in a fixed cycle. Checking pillar strings alone doesn't
  /// catch a frozen stem (the branch still varies, so the strings stay
  /// distinct even when the stem is constant); this isolates the stem.
  ///
  /// There are only 10 heavenly stems for 12 branches, so by pigeonhole all
  /// 10 must appear (2 repeat) — not fewer, and never collapsed to 1.
  @Test func hourStemVariesAcrossOneDay() throws {
    let dayPillar = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2010, month: 4, day: 12).riZhu
    #expect(dayPillar?.description == "壬辰")

    var stems: Set<Int> = []
    for hour in 0..<24 {
      let component = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2010, month: 4, day: 12, hour: hour)
      if let gan = component.shiGan {
        stems.insert(gan.rawValue)
      }
    }
    #expect(stems.count == 10, "Expected all 10 hour stems to appear, got \(stems.count): \(stems.sorted())")
  }

  /// Known-good pillars verified independently against the 五鼠遁/年上起月 rules
  /// and Apple's own Chinese-calendar day count, for 2025-06-09 12:00 CST.
  @Test func knownGoodPillarsFor2025_06_09() throws {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(secondsFromGMT: 8 * 3600)!
    let date = try #require(cal.date(from: DateComponents(year: 2025, month: 6, day: 9, hour: 12)))
    let bazi = try #require(Bazi(date: date))

    #expect(bazi.nian.description == "乙巳")
    #expect(bazi.yue.description == "壬午")
    #expect(bazi.ri.description == "己酉")
    #expect(bazi.shi.description == "庚午")
  }

  /// `nianZhi` must not trap for years far outside the 60-cycle offset window.
  /// Pre-fix, `year = -3000` drives `Dizhi.allCases[-4]` — an index-out-of-range
  /// fatal error, not a graceful failure. (Confirmed by hand: adjustedYear =
  /// -3000 + 2697 = -303; -303 % 60 == -3 in Swift; adjusted stays -3.)
  @Test func yearBranchNeverTrapsForExtremeYears() {
    for year in [-3000, -10_000, -2697, -2696, 0] {
      let component = DateComponents(calendar: Calendar(identifier: .gregorian), year: year, month: 1, day: 1)
      _ = component.nianZhi
      _ = component.nianGan
    }
  }
}
