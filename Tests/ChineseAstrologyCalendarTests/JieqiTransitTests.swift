import Foundation
import Testing
@testable import ChineseAstrologyCalendar

/// Reference instants are the Hong Kong Observatory's "24 Solar Terms"
/// almanac sheets (Hong Kong Time, UTC+8, to the minute; HKO credits
/// HM Nautical Almanac Office / USNO data):
/// https://www.hko.gov.hk/en/gts/astron2025/files/2025SolarTerms24.pdf
/// https://www.hko.gov.hk/en/gts/astron2026/files/2026SolarTerms24.pdf
///
/// Astral's low-precision solar theory (no ΔT) puts transits up to about
/// 12 minutes from these values (−12.0 min for 穀雨 2025, +4.8 min for
/// 秋分 2026), so the tolerance is 15 minutes rather than 1 minute.
@Suite struct JieqiTransitTests {

  static let tolerance: TimeInterval = 15 * 60

  static func hkt(_ text: String) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = .chinaStandardTime
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter.date(from: text)!
  }

  /// HKO major solar terms (中氣), 2025 and 2026, plus 立春 2026 (published 04:02).
  static let hkoReference: [(Jieqi, String)] = [
    (.majorCold, "2025-01-20 04:00"), (.rainWater, "2025-02-18 18:07"),
    (.springEquinox, "2025-03-20 17:01"), (.grainRain, "2025-04-20 03:56"),
    (.grainBuds, "2025-05-21 02:55"), (.summerSolstice, "2025-06-21 10:42"),
    (.majorHeat, "2025-07-22 21:29"), (.endOfHeat, "2025-08-23 04:34"),
    (.autumnEquinox, "2025-09-23 02:19"), (.frostDescent, "2025-10-23 11:51"),
    (.minorSnow, "2025-11-22 09:36"), (.winterSolstice, "2025-12-21 23:03"),
    (.majorCold, "2026-01-20 09:45"), (.rainWater, "2026-02-18 23:52"),
    (.springEquinox, "2026-03-20 22:46"), (.grainRain, "2026-04-20 09:39"),
    (.grainBuds, "2026-05-21 08:37"), (.summerSolstice, "2026-06-21 16:25"),
    (.majorHeat, "2026-07-23 03:13"), (.endOfHeat, "2026-08-23 10:19"),
    (.autumnEquinox, "2026-09-23 08:05"), (.frostDescent, "2026-10-23 17:38"),
    (.minorSnow, "2026-11-22 15:23"), (.winterSolstice, "2026-12-22 04:50"),
    (.startOfSpring, "2026-02-04 04:02"),
  ]

  // MARK: - Solar longitude

  @Test func solarLongitudeIsNormalized() {
    var date = Self.hkt("2026-01-01 00:00")
    for _ in 0..<73 {
      let longitude = date.solarLongitude
      #expect(longitude >= 0 && longitude < 360)
      date = date.addingTimeInterval(5 * 86_400)
    }
  }

  @Test func solarLongitudeWrapsAtSpringEquinox() {
    let equinox = Jieqi.springEquinox.transit(after: Self.hkt("2026-03-01 00:00"))
    #expect(equinox.addingTimeInterval(-60).solarLongitude > 359.9)
    #expect(equinox.addingTimeInterval(60).solarLongitude < 0.1)
  }

  // MARK: - Published instants

  @Test func matchesHongKongObservatoryInstants() {
    for (jieqi, text) in Self.hkoReference {
      let reference = Self.hkt(text)
      let computed = jieqi.transit(after: reference.addingTimeInterval(-10 * 86_400))
      #expect(abs(computed.timeIntervalSince(reference)) < Self.tolerance, "\(jieqi.chineseName) \(text): \(computed)")
    }
  }

  @Test func transitLandsOnTargetLongitude() {
    for jieqi in Jieqi.allCases {
      let instant = jieqi.transit(after: Self.hkt("2026-01-01 00:00"))
      let target = Double(jieqi.celestialLongitude)
      let before = instant.addingTimeInterval(-2).solarLongitude
      let after = instant.addingTimeInterval(2).solarLongitude
      #expect(Jieqi.containing(longitude: before) == Jieqi(rawValue: (jieqi.rawValue + 23) % 24))
      #expect(Jieqi.containing(longitude: after) == jieqi)
      #expect(abs(normalizedDegrees(after - target + 180) - 180) < 0.001)
    }
  }

  // MARK: - after / before

  @Test func afterAndBeforeAreStrictAndInverse() {
    let start = Self.hkt("2026-06-01 12:00")
    for jieqi in Jieqi.allCases {
      let next = jieqi.transit(after: start)
      let previous = jieqi.transit(before: start)
      #expect(next > start)
      #expect(previous < start)
      let gap = next.timeIntervalSince(previous) / 86_400
      #expect(gap > 365 && gap < 366)
      // Asking from the transit instant itself moves to the neighbouring year.
      #expect(jieqi.transit(after: next).timeIntervalSince(next) > 360 * 86_400)
      #expect(next.timeIntervalSince(jieqi.transit(before: next)) > 360 * 86_400)
      #expect(abs(jieqi.transit(before: next.addingTimeInterval(3)).timeIntervalSince(next)) < 2)
    }
  }

  @Test func springEquinoxAcrossTheWrap() {
    // From mid-winter the sun is behind 0° and must cross 360° → 0°.
    let fromWinter = Jieqi.springEquinox.transit(after: Self.hkt("2026-01-10 00:00"))
    let fromAutumn = Jieqi.springEquinox.transit(before: Self.hkt("2026-10-01 00:00"))
    #expect(abs(fromWinter.timeIntervalSince(fromAutumn)) < 2)
    #expect(abs(fromWinter.timeIntervalSince(Self.hkt("2026-03-20 22:46"))) < Self.tolerance)
  }

  @Test func transitInYear() {
    let solstice = Jieqi.summerSolstice.transit(inYear: 2026)
    #expect(solstice.map { abs($0.timeIntervalSince(Self.hkt("2026-06-21 16:25"))) < Self.tolerance } == true)
    let minorCold = Jieqi.minorCold.transit(inYear: 2026)
    #expect(minorCold.map { transitCalendar(in: .chinaStandardTime).component(.month, from: $0) } == 1)
  }

  @Test func nextAndPreviousTransitOfDate() {
    let date = Self.hkt("2026-03-10 12:00") // inside 驚蟄
    #expect(date.previousJieqiTransit.jieqi == .awakeningOfInsects)
    #expect(date.nextJieqiTransit.jieqi == .springEquinox)
    #expect(date.previousJieqiTransit.instant < date)
    #expect(date.nextJieqiTransit.instant > date)
    // At a transit instant the previous transit is that one, the next is the following term.
    let instant = date.nextJieqiTransit.instant
    #expect(instant.previousJieqiTransit.jieqi == .springEquinox)
    #expect(instant.nextJieqiTransit.jieqi == .clearAndBright)
  }

  // MARK: - A year of transits

  @Test(arguments: [1990, 2025, 2026, 2050])
  func yearHasTwentyFourOrderedTransits(year: Int) {
    let transits = JieqiTransit.transits(inYear: year)
    #expect(transits.count == 24)
    #expect(transits.first?.jieqi == .minorCold)
    #expect(transits.last?.jieqi == .winterSolstice)
    #expect(Set(transits.map(\.jieqi)).count == 24)
    for (earlier, later) in zip(transits, transits.dropFirst()) {
      #expect(later.jieqi == earlier.jieqi.next)
      let days = later.instant.timeIntervalSince(earlier.instant) / 86_400
      #expect(days > 14 && days < 16.5)
    }
    #expect(transits == transits.sorted())
  }

  @Test func yearRespectsTimeZone() {
    let calendar = transitCalendar(in: TimeZone(identifier: "America/Los_Angeles")!)
    for transit in JieqiTransit.transits(inYear: 2026, timeZone: calendar.timeZone) {
      #expect(calendar.component(.year, from: transit.instant) == 2026)
    }
  }

  // MARK: - Consistency with the day-level API

  @Test(arguments: [
    TimeZone.chinaStandardTime,
    TimeZone(identifier: "UTC")!,
    TimeZone(identifier: "America/New_York")!,
  ])
  func transitDayMatchesDayLevelJieqi(timeZone: TimeZone) {
    for year in [2025, 2026] {
      for transit in JieqiTransit.transits(inYear: year, timeZone: timeZone) {
        let day = transit.day(in: timeZone)
        #expect(day.jieqi(in: timeZone) == transit.jieqi)
        #expect(day.isJieqiDay(in: timeZone))
        let start = transit.jieqi.startDate(in: transit.instant, timeZone: timeZone)
        #expect(start.map { transitCalendar(in: timeZone).startOfDay(for: $0) } == day)
      }
    }
  }

  /// HKO 2026 dates (UTC+8) for the minor terms (節), which the almanac sheet
  /// lists by date only.
  @Test func minorTermDays2026() {
    let expected: [Jieqi: (Int, Int)] = [
      .minorCold: (1, 5), .startOfSpring: (2, 4), .awakeningOfInsects: (3, 5),
      .clearAndBright: (4, 5), .startOfSummer: (5, 5), .grainInEar: (6, 5),
      .minorHeat: (7, 7), .startOfAutumn: (8, 7), .whiteDew: (9, 7),
      .coldDew: (10, 8), .startOfWinter: (11, 7), .majorSnow: (12, 7),
    ]
    for transit in JieqiTransit.transits(inYear: 2026) where !transit.jieqi.qi {
      let components = transit.dayComponents(in: .chinaStandardTime)
      let want = expected[transit.jieqi]
      #expect(components.month == want?.0 && components.day == want?.1, "\(transit.jieqi.chineseName)")
    }
  }
}
