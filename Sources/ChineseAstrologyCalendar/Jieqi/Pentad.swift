import Foundation

// MARK: - 候 (pentads)
//
// Each solar term splits into three 候 of 5° of solar longitude (about five
// days each), 72 in a year. The phenological texts come from `qishierHou`,
// "X之日A，又五日B，又五日C", split on 又五日.

extension Jieqi {

  /// The term's three 候 texts (七十二候), in order, in Traditional Chinese,
  /// e.g. 立春 → ["東風解凍", "蟄蟲始振", "魚上冰（魚陟負冰)"].
  public var pentads: [String] {
    let parts = qishierHou.components(separatedBy: "又五日")
    guard parts.count == 3 else { return [] }
    return parts.enumerated().map { index, raw in
      var text = Substring(raw)
      if index == 0, let range = text.range(of: "之日") {
        text = text[range.upperBound...]
      }
      return text.trimmingCharacters(in: CharacterSet(charactersIn: "，,。 "))
    }
  }
}

/// One of the 72 候: a third of a solar term, starting where the sun's
/// ecliptic longitude reaches a multiple of 5°.
public struct Pentad: Hashable, Comparable, Sendable {
  /// The term the 候 belongs to.
  public let jieqi: Jieqi
  /// 0, 1 or 2: 初候, 二候, 三候.
  public let index: Int

  public init(jieqi: Jieqi, index: Int) {
    precondition((0..<3).contains(index), "A term has three pentads")
    self.jieqi = jieqi
    self.index = index
  }

  /// The 候 whose 5° band contains `longitude` (degrees).
  public init(longitude: Double) {
    let band = Int(normalizedDegrees(longitude) / 5) % 72
    self.init(jieqi: Jieqi(rawValue: band / 3) ?? .springEquinox, index: band % 3)
  }

  /// Position in the year counted from 春分's first 候 (0...71), matching
  /// `Jieqi`'s raw values.
  public var ordinal: Int { jieqi.rawValue * 3 + index }

  /// The ecliptic longitude (degrees) at which this 候 begins.
  public var startLongitude: Double { Double(ordinal * 5) }

  /// The phenological text, e.g. "東風解凍" (Traditional Chinese).
  public var text: String {
    let texts = jieqi.pentads
    return texts.indices.contains(index) ? texts[index] : ""
  }

  /// The 候 that follows this one.
  public var next: Pentad { Pentad(longitude: startLongitude + 5) }

  /// The 候 that precedes this one.
  public var previous: Pentad { Pentad(longitude: startLongitude - 5) }

  /// The first instant after `date` at which this 候 begins.
  public func start(after date: Date) -> Date {
    solarLongitudeCrossing(startLongitude, after: date)
  }

  /// The last instant before `date` at which this 候 began.
  public func start(before date: Date) -> Date {
    solarLongitudeCrossing(startLongitude, before: date)
  }

  public static func < (lhs: Pentad, rhs: Pentad) -> Bool { lhs.ordinal < rhs.ordinal }
}

/// A 候 together with the instant it begins.
public struct PentadBoundary: Hashable, Comparable, Sendable {
  public let pentad: Pentad
  public let instant: Date

  public init(pentad: Pentad, instant: Date) {
    self.pentad = pentad
    self.instant = instant
  }

  public static func < (lhs: PentadBoundary, rhs: PentadBoundary) -> Bool { lhs.instant < rhs.instant }

  /// Every 候 that begins in `[start, end)`, in order. A crossing within a
  /// second of `start` or `end` counts as at that instant. Boundaries with
  /// `pentad.index == 0` are the solar term transits.
  public static func boundaries(from start: Date, to end: Date) -> [PentadBoundary] {
    guard start < end else { return [] }
    var result: [PentadBoundary] = []
    // Search from just before `start` so a 候 beginning at `start` (within
    // the crossing resolution) is included.
    var cursor = start.addingTimeInterval(-2 * crossingResolution)
    var pentad = cursor.pentad.next
    while true {
      let instant = pentad.start(after: cursor)
      // A crossing within the resolution of `end` counts as at `end`.
      guard end.timeIntervalSince(instant) > crossingResolution else { break }
      result.append(PentadBoundary(pentad: pentad, instant: instant))
      cursor = instant
      pentad = pentad.next
    }
    return result
  }

  /// The 候 beginning in the Gregorian `year` as reckoned in `timeZone`.
  /// Boundaries average 5.07 days apart, so a calendar year holds 71 or 72
  /// of them; all 24 term transits are always included.
  public static func boundaries(inYear year: Int, timeZone: TimeZone = .chinaStandardTime) -> [PentadBoundary] {
    let calendar = transitCalendar(in: timeZone)
    guard let start = calendar.date(from: DateComponents(year: year, month: 1, day: 1)),
      let end = calendar.date(from: DateComponents(year: year + 1, month: 1, day: 1))
    else { return [] }
    return boundaries(from: start, to: end)
  }
}

extension Date {

  /// The 候 the sun is in at this instant.
  public var pentad: Pentad { Pentad(longitude: solarLongitude) }

  /// 0, 1 or 2: which 候 of the current solar term this instant falls in.
  public var pentadIndex: Int { pentad.index }

  /// The start of the 候 in progress at this instant.
  public var currentPentadBoundary: PentadBoundary {
    let pentad = self.pentad
    return PentadBoundary(pentad: pentad, instant: pentad.start(before: addingTimeInterval(crossingResolution * 2)))
  }

  /// The next 候 to begin after this instant.
  public var nextPentadBoundary: PentadBoundary {
    let next = pentad.next
    return PentadBoundary(pentad: next, instant: next.start(after: self))
  }
}
