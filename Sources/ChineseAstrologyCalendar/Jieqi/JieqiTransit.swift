import Astral
import Foundation

// MARK: - 交節時刻 (exact transit instants)
//
// The day-level API in `Jieqi.swift` answers "which term is this calendar day
// in?" by sampling the sun at the end of the day. The API here answers "at
// what instant does the sun reach the term's ecliptic longitude?", found by
// bisection on Astral's apparent solar longitude.
//
// Precision: Astral uses a low-precision solar theory and no ΔT (TT − UT)
// correction, so instants can differ from published almanac times by several
// minutes (up to about 12 minutes in 2025–2026 against the Hong Kong
// Observatory's tables). The bisection converges to within one second of
// Astral's own crossing, so a crossing less than a second from the query
// instant counts as being at that instant.

extension Date {

  /// The sun's apparent geocentric ecliptic longitude at this instant, in
  /// degrees in `0..<360`, as computed by Astral.
  ///
  /// 0° is the 春分 (spring equinox) point; each solar term starts at a
  /// multiple of 15° (`Jieqi.celestialLongitude`).
  public var solarLongitude: Double {
    normalizedDegrees(currentSolarTerm(for: self) * 15 - 7.5)
  }

  /// The next solar term transit strictly after this instant.
  public var nextJieqiTransit: JieqiTransit {
    let upcoming = Jieqi.containing(longitude: solarLongitude).next
    return JieqiTransit(jieqi: upcoming, instant: upcoming.transit(after: self))
  }

  /// The most recent solar term transit at or before this instant: the start
  /// of the term period this instant is in.
  public var previousJieqiTransit: JieqiTransit {
    let current = Jieqi.containing(longitude: solarLongitude)
    return JieqiTransit(jieqi: current, instant: current.transit(before: self.addingTimeInterval(2)))
  }
}

// MARK: - JieqiTransit

/// A solar term together with the exact instant the sun reaches its
/// ecliptic longitude (交節時刻).
public struct JieqiTransit: Hashable, Comparable, Sendable {

  /// The solar term that begins at `instant`.
  public let jieqi: Jieqi

  /// The moment the sun's apparent longitude reaches `jieqi.celestialLongitude`.
  public let instant: Date

  public init(jieqi: Jieqi, instant: Date) {
    self.jieqi = jieqi
    self.instant = instant
  }

  public static func < (lhs: JieqiTransit, rhs: JieqiTransit) -> Bool {
    lhs.instant < rhs.instant
  }

  /// The start of the calendar day in `timeZone` that contains the transit.
  /// This is the day almanacs print as the term's day.
  public func day(in timeZone: TimeZone) -> Date {
    transitCalendar(in: timeZone).startOfDay(for: instant)
  }

  /// Year, month and day of the transit's calendar day in `timeZone`.
  public func dayComponents(in timeZone: TimeZone) -> DateComponents {
    transitCalendar(in: timeZone).dateComponents([.year, .month, .day], from: instant)
  }

  /// All 24 transits whose instant falls inside the Gregorian `year` as
  /// reckoned in `timeZone`, in chronological order (小寒 first, 冬至 last).
  public static func transits(inYear year: Int, timeZone: TimeZone = .chinaStandardTime) -> [JieqiTransit] {
    let calendar = transitCalendar(in: timeZone)
    guard
      let start = calendar.date(from: DateComponents(year: year, month: 1, day: 1)),
      let end = calendar.date(from: DateComponents(year: year + 1, month: 1, day: 1))
    else { return [] }

    var result: [JieqiTransit] = []
    var cursor = start
    while result.count < 25 {
      let transit = cursor.nextJieqiTransit
      guard transit.instant < end else { break }
      result.append(transit)
      // Restart a day later so a longitude that rounds just below the
      // boundary at the instant itself cannot select the same term again.
      cursor = transit.instant.addingTimeInterval(86_400)
    }
    return result
  }
}

// MARK: - Jieqi transit queries

extension Jieqi {

  /// The first instant after `date` at which the sun reaches this term's
  /// ecliptic longitude. A crossing within a second of `date` counts as at
  /// `date` and is skipped, so passing a transit instant returns the next year's.
  public func transit(after date: Date) -> Date {
    let target = Double(celestialLongitude)
    let ahead = normalizedDegrees(target - date.solarLongitude)
    let found = refineCrossing(of: target, near: date.addingTimeInterval(ahead / 360 * tropicalYear))
    if found.timeIntervalSince(date) > crossingResolution { return found }
    // The crossing at `date` itself (or a hair before it) was found; the
    // next one is a year later.
    return transit(after: date.addingTimeInterval(86_400))
  }

  /// The last instant before `date` at which the sun reached this term's
  /// ecliptic longitude. A crossing within a second of `date` counts as at
  /// `date` and is skipped, so passing a transit instant returns the previous year's.
  public func transit(before date: Date) -> Date {
    let target = Double(celestialLongitude)
    let behind = normalizedDegrees(date.solarLongitude - target)
    let found = refineCrossing(of: target, near: date.addingTimeInterval(-behind / 360 * tropicalYear))
    if date.timeIntervalSince(found) > crossingResolution { return found }
    return transit(before: date.addingTimeInterval(-86_400))
  }

  /// The transit of this term inside the Gregorian `year` as reckoned in
  /// `timeZone`. Every term transits once per Gregorian year.
  public func transit(inYear year: Int, timeZone: TimeZone = .chinaStandardTime) -> Date? {
    let calendar = transitCalendar(in: timeZone)
    guard let start = calendar.date(from: DateComponents(year: year, month: 1, day: 1)) else { return nil }
    let instant = transit(after: start.addingTimeInterval(-1))
    guard calendar.component(.year, from: instant) == year else { return nil }
    return instant
  }

  /// The term whose 15° band contains `longitude` (degrees).
  static func containing(longitude: Double) -> Jieqi {
    let index = Int(normalizedDegrees(longitude) / 15) % 24
    return Jieqi(rawValue: index) ?? .springEquinox
  }
}

// MARK: - Root finding

/// How closely `refineCrossing` pins a crossing, in seconds.
private let crossingResolution: TimeInterval = 1

/// Mean tropical year, used only to seed the bisection.
private let tropicalYear: TimeInterval = 365.242_19 * 86_400

/// `degrees` reduced to `0..<360`.
func normalizedDegrees(_ degrees: Double) -> Double {
  let reduced = degrees.truncatingRemainder(dividingBy: 360)
  return reduced < 0 ? reduced + 360 : reduced
}

/// `a − b` reduced to `-180..<180`, so the 360°→0° wrap at 春分 compares correctly.
private func signedDelta(_ a: Double, _ b: Double) -> Double {
  let delta = normalizedDegrees(a - b)
  return delta >= 180 ? delta - 360 : delta
}

/// Finds the instant within a few days of `estimate` at which the solar
/// longitude reaches `target`, to within one second.
private func refineCrossing(of target: Double, near estimate: Date) -> Date {
  let day: TimeInterval = 86_400
  var low = estimate.addingTimeInterval(-4 * day)
  var high = estimate.addingTimeInterval(4 * day)
  // The mean-motion estimate is within about two days of the true crossing;
  // widen the bracket if an extreme case falls outside it.
  for _ in 0..<8 where signedDelta(low.solarLongitude, target) >= 0 {
    low = low.addingTimeInterval(-4 * day)
  }
  for _ in 0..<8 where signedDelta(high.solarLongitude, target) < 0 {
    high = high.addingTimeInterval(4 * day)
  }
  for _ in 0..<48 where high.timeIntervalSince(low) > crossingResolution {
    let mid = low.addingTimeInterval(high.timeIntervalSince(low) / 2)
    if signedDelta(mid.solarLongitude, target) < 0 {
      low = mid
    } else {
      high = mid
    }
  }
  return high
}

func transitCalendar(in timeZone: TimeZone) -> Calendar {
  var calendar = Calendar(identifier: .gregorian)
  calendar.timeZone = timeZone
  return calendar
}
