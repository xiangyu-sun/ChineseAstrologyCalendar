import Foundation

// MARK: - 數九, 三伏, 梅雨 (folk seasonal counts)
//
// Date arithmetic only: each count is anchored on a solar term's transit day
// (from `JieqiTransit.swift`) and, for 三伏 and 梅雨, on the day's stem or
// branch (`riZhu`). Days are calendar days in the time zone passed in, which
// defaults to China Standard Time, the zone the almanac rules are written for.
//
// Rules, and where schools differ:
// - 數九: 一九 begins on the day of 冬至 and each 九 lasts nine days, 81 days in
//   all. Some regions start counting the day after 冬至 instead.
// - 三伏: 初伏 begins on the third 庚 day counted from the day of 夏至, 中伏 on
//   the fourth, 末伏 on the first 庚 day counted from the day of 立秋; 末伏 lasts
//   ten days. A term day that is itself a 庚 day counts as the first. 初伏 is
//   always ten days and 中伏 runs until 末伏, so it lasts ten or twenty days.
//   Some almanacs count only 庚 days strictly after the term day.
// - 梅雨: 入梅 is the first 丙 day counted from the day of 芒種 and 出梅 the
//   first 未 day counted from the day of 小暑, a term day included (the
//   almanac rule of 《神樞經》). Other almanacs use different stems (e.g. 壬
//   days after 芒種), and the rainy season meteorological services announce
//   each year follows the weather, not this rule.

/// A folk seasonal count running on a given day.
public struct SeasonalCount: Hashable, Sendable {

  public enum Kind: Int, CaseIterable, Hashable, Sendable {
    /// 數九: nine nine-day periods from 冬至.
    case nines
    /// 三伏: 初伏, 中伏 and 末伏 in high summer.
    case dogDays
    /// 梅雨: from 入梅 to 出梅.
    case plumRains
  }

  /// One named period of a count: 一九…九九, 初伏/中伏/末伏, or the single
  /// period of 梅雨.
  public struct Period: Hashable, Sendable {
    public let kind: Kind
    /// 0...8 for 數九, 0...2 for 三伏, 0 for 梅雨.
    public let index: Int

    public init(kind: Kind, index: Int) {
      precondition((0..<kind.periodCount).contains(index), "No such period")
      self.kind = kind
      self.index = index
    }
  }

  public let kind: Kind
  /// Index of the current period (see `Period.index`).
  public let period: Int
  /// 1-based day within the current period.
  public let day: Int
  /// Length of the current period in days.
  public let periodLength: Int
  /// Start of the first day of the whole count.
  public let start: Date
  /// Start of the day after the count ends.
  public let end: Date

  public init(kind: Kind, period: Int, day: Int, periodLength: Int, start: Date, end: Date) {
    self.kind = kind
    self.period = period
    self.day = day
    self.periodLength = periodLength
    self.start = start
    self.end = end
  }

  /// The current period, for its name.
  public var currentPeriod: Period { Period(kind: kind, index: period) }
}

extension SeasonalCount.Kind {
  /// How many periods the count has.
  public var periodCount: Int {
    switch self {
    case .nines: return 9
    case .dogDays: return 3
    case .plumRains: return 1
    }
  }
}

// MARK: - Dates of a year's counts

/// The three 伏 of a year. All values are starts of days.
public struct DogDays: Hashable, Sendable {
  /// First day of 初伏.
  public let early: Date
  /// First day of 中伏 (ten days after 初伏).
  public let middle: Date
  /// First day of 末伏.
  public let late: Date
  /// The day after 末伏 ends (ten days after 末伏 begins).
  public let end: Date

  /// Starts of 初伏, 中伏, 末伏 and the end, in order.
  var boundaries: [Date] { [early, middle, late, end] }
}

/// A year's 梅雨 by the almanac rule. Both values are starts of days.
public struct PlumRains: Hashable, Sendable {
  /// 入梅.
  public let start: Date
  /// The day after 出梅.
  public let end: Date
}

extension SeasonalCount {

  /// Every count running on the day containing `date`.
  public static func active(on date: Date, timeZone: TimeZone = .chinaStandardTime) -> [SeasonalCount] {
    [nines(on: date, timeZone: timeZone), dogDays(on: date, timeZone: timeZone),
     plumRains(on: date, timeZone: timeZone)].compactMap { $0 }
  }

  /// The 數九 count on the day containing `date`, or nil outside the 81 days.
  public static func nines(on date: Date, timeZone: TimeZone = .chinaStandardTime) -> SeasonalCount? {
    let calendar = transitCalendar(in: timeZone)
    let today = calendar.startOfDay(for: date)
    guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) else { return nil }
    let solstice = calendar.startOfDay(for: Jieqi.winterSolstice.transit(before: tomorrow))
    let offset = days(from: solstice, to: today, calendar)
    guard (0..<81).contains(offset), let end = calendar.date(byAdding: .day, value: 81, to: solstice)
    else { return nil }
    return SeasonalCount(
      kind: .nines, period: offset / 9, day: offset % 9 + 1, periodLength: 9, start: solstice, end: end)
  }

  /// The 三伏 count on the day containing `date`, or nil outside it.
  public static func dogDays(on date: Date, timeZone: TimeZone = .chinaStandardTime) -> SeasonalCount? {
    let calendar = transitCalendar(in: timeZone)
    let today = calendar.startOfDay(for: date)
    guard let fu = dogDays(inYear: calendar.component(.year, from: today), timeZone: timeZone),
      today >= fu.early, today < fu.end
    else { return nil }
    let starts = fu.boundaries
    let period = today < fu.middle ? 0 : today < fu.late ? 1 : 2
    return SeasonalCount(
      kind: .dogDays, period: period,
      day: days(from: starts[period], to: today, calendar) + 1,
      periodLength: days(from: starts[period], to: starts[period + 1], calendar),
      start: fu.early, end: fu.end)
  }

  /// The 梅雨 count on the day containing `date`, or nil outside it.
  public static func plumRains(on date: Date, timeZone: TimeZone = .chinaStandardTime) -> SeasonalCount? {
    let calendar = transitCalendar(in: timeZone)
    let today = calendar.startOfDay(for: date)
    guard let rains = plumRains(inYear: calendar.component(.year, from: today), timeZone: timeZone),
      today >= rains.start, today < rains.end
    else { return nil }
    return SeasonalCount(
      kind: .plumRains, period: 0, day: days(from: rains.start, to: today, calendar) + 1,
      periodLength: days(from: rains.start, to: rains.end, calendar), start: rains.start, end: rains.end)
  }

  /// The year's 三伏: 初伏 on the 3rd 庚 day from 夏至, 中伏 on the 4th, 末伏 on
  /// the 1st 庚 day from 立秋, ending ten days later.
  public static func dogDays(inYear year: Int, timeZone: TimeZone = .chinaStandardTime) -> DogDays? {
    let calendar = transitCalendar(in: timeZone)
    guard let solstice = Jieqi.summerSolstice.transit(inYear: year, timeZone: timeZone),
      let autumn = Jieqi.startOfAutumn.transit(inYear: year, timeZone: timeZone),
      let early = day(onOrAfter: calendar.startOfDay(for: solstice), nth: 3, calendar, where: { $0.gan == .geng }),
      let late = day(onOrAfter: calendar.startOfDay(for: autumn), nth: 1, calendar, where: { $0.gan == .geng }),
      let middle = calendar.date(byAdding: .day, value: 10, to: early),
      let end = calendar.date(byAdding: .day, value: 10, to: late)
    else { return nil }
    return DogDays(early: early, middle: middle, late: late, end: end)
  }

  /// The year's 梅雨: 入梅 on the 1st 丙 day from 芒種, 出梅 on the 1st 未 day
  /// from 小暑.
  public static func plumRains(inYear year: Int, timeZone: TimeZone = .chinaStandardTime) -> PlumRains? {
    let calendar = transitCalendar(in: timeZone)
    guard let grain = Jieqi.grainInEar.transit(inYear: year, timeZone: timeZone),
      let heat = Jieqi.minorHeat.transit(inYear: year, timeZone: timeZone),
      let start = day(onOrAfter: calendar.startOfDay(for: grain), nth: 1, calendar, where: { $0.gan == .bing }),
      let last = day(onOrAfter: calendar.startOfDay(for: heat), nth: 1, calendar, where: { $0.zhi == .wei }),
      let end = calendar.date(byAdding: .day, value: 1, to: last)
    else { return nil }
    return PlumRains(start: start, end: end)
  }

  // MARK: Helpers

  private static func days(from start: Date, to end: Date, _ calendar: Calendar) -> Int {
    calendar.dateComponents([.day], from: start, to: end).day ?? 0
  }

  /// The `nth` day on or after `start` whose day pillar matches.
  private static func day(
    onOrAfter start: Date, nth: Int, _ calendar: Calendar, where matches: (Ganzhi) -> Bool
  ) -> Date? {
    var found = 0
    var day = start
    // Stems repeat every 10 days and branches every 12, so 60 days is ample.
    for _ in 0..<60 {
      if let ganzhi = calendar.dateComponents([.year, .month, .day], from: day).riZhu, matches(ganzhi) {
        found += 1
        if found == nth { return day }
      }
      guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { return nil }
      day = next
    }
    return nil
  }
}

// MARK: - Names

extension SeasonalCount.Kind: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch (self, language.base) {
    case (.nines, .zhHant): return "數九"
    case (.nines, .zhHans): return "数九"
    case (.nines, .en): return "Counting the Nines"
    case (.dogDays, .zhHant), (.dogDays, .zhHans): return "三伏"
    case (.dogDays, .en): return "Dog Days"
    case (.plumRains, .zhHant), (.plumRains, .zhHans): return "梅雨"
    case (.plumRains, .en): return "Plum Rains"
    }
  }
}

extension SeasonalCount.Period: LocalizedNaming {
  private static let nineNames = ["一九", "二九", "三九", "四九", "五九", "六九", "七九", "八九", "九九"]
  private static let nineEnglish = [
    "First Nine", "Second Nine", "Third Nine", "Fourth Nine", "Fifth Nine",
    "Sixth Nine", "Seventh Nine", "Eighth Nine", "Ninth Nine",
  ]
  private static let fuNames = ["初伏", "中伏", "末伏"]
  private static let fuEnglish = ["Early Fu", "Middle Fu", "Late Fu"]

  public func localizedName(in language: DisplayLanguage) -> String {
    let english = language.base == .en
    switch kind {
    case .nines: return english ? Self.nineEnglish[index] : Self.nineNames[index]
    case .dogDays: return english ? Self.fuEnglish[index] : Self.fuNames[index]
    case .plumRains: return kind.localizedName(in: language)
    }
  }
}

extension SeasonalCount: LocalizedNaming {
  /// The name of the current period, e.g. 三九 or 中伏.
  public func localizedName(in language: DisplayLanguage) -> String {
    currentPeriod.localizedName(in: language)
  }
}
