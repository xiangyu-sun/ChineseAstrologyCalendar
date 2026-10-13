import Foundation

// MARK: - RecurringDay

/// A day that recurs every year on a fixed lunar or Gregorian date — a
/// birthday, an anniversary, a family memorial day.
///
/// Feed these to ``RecurringDaySource`` to surface them alongside the built-in
/// festivals and solar terms:
///
/// ```swift
/// let birthday = RecurringDay(name: "媽媽生日", reckoning: .lunar, month: 8, day: 3)
/// let sources: [SpecialDaySource] = [FestivalSource(), JieqiSource(), RecurringDaySource(days: [birthday])]
/// ```
public struct RecurringDay: Hashable, Codable, Sendable {

  /// Which calendar `month` and `day` are counted in.
  public enum Reckoning: String, Hashable, Codable, Sendable, CaseIterable {
    /// The Chinese lunar calendar. `month` is 1–12 (正月–臘月), `day` 1–30.
    /// Leap months are skipped: the day falls in the regular month only.
    case lunar
    /// The Gregorian calendar. `month` is 1–12, `day` 1–31.
    case gregorian
  }

  /// The display name, e.g. "媽媽生日".
  public var name: String
  /// An optional subtitle shown as ``SpecialDay/detail``.
  public var detail: String
  public var reckoning: Reckoning
  public var month: Int
  public var day: Int

  public init(name: String, detail: String = "", reckoning: Reckoning, month: Int, day: Int) {
    self.name = name
    self.detail = detail
    self.reckoning = reckoning
    self.month = month
    self.day = day
  }

  /// Whether `month` and `day` are in range for ``reckoning``.
  public var isValid: Bool {
    let maxDay = reckoning == .lunar ? 30 : 31
    return (1...12).contains(month) && (1...maxDay).contains(day)
  }
}

// MARK: - RecurringDaySource

/// A `SpecialDaySource` for user-defined ``RecurringDay``s.
///
/// When a month is shorter than the requested day — lunar 三十 in a 29-day
/// month, or 2月29日 outside a leap year — the day falls on the month's last
/// day instead, so it is never skipped for a year.
public struct RecurringDaySource: SpecialDaySource {

  /// The default category string used in `SpecialDay.category`.
  public static let categoryName = "自訂"

  public let days: [RecurringDay]
  public let timeZone: TimeZone
  private let category: String

  /// - Parameters:
  ///   - days: The days to surface. Invalid days are ignored.
  ///   - timeZone: The time zone whose calendar days the dates fall on. Use
  ///     the same one as the other sources you combine this with.
  ///   - category: The label used for ``SpecialDay/category``.
  public init(days: [RecurringDay], timeZone: TimeZone = .current, category: String = RecurringDaySource.categoryName) {
    self.days = days.filter(\.isValid)
    self.timeZone = timeZone
    self.category = category
  }

  public func specialDays(on date: Date) -> [SpecialDay] {
    let gregorian = gregorianCalendar
    return days.compactMap { day in
      let hit = (-1...1).contains { offset in
        occurrence(of: day, yearOffset: offset, from: date).map { gregorian.isDate($0, inSameDayAs: date) } ?? false
      }
      return hit ? specialDay(for: day, on: date) : nil
    }
  }

  public func nextSpecialDay(after date: Date) -> SpecialDay? {
    guard let tomorrow = gregorianCalendar.date(byAdding: .day, value: 1, to: gregorianCalendar.startOfDay(for: date)) else {
      return nil
    }
    let candidates = days.compactMap { day -> (RecurringDay, Date)? in
      nextOccurrence(of: day, onOrAfter: tomorrow).map { (day, $0) }
    }
    guard let (day, next) = candidates.min(by: { $0.1 < $1.1 }) else { return nil }
    return specialDay(for: day, on: next)
  }

  /// The first occurrence of `day` on or after the calendar day of `date`.
  public func nextOccurrence(of day: RecurringDay, onOrAfter date: Date) -> Date? {
    guard day.isValid else { return nil }
    let start = gregorianCalendar.startOfDay(for: date)
    return (-1...2)
      .compactMap { occurrence(of: day, yearOffset: $0, from: date) }
      .filter { $0 >= start }
      .min()
  }

  // MARK: Private

  private var gregorianCalendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = timeZone
    return calendar
  }

  private var lunarCalendar: Calendar {
    var calendar = Calendar(identifier: .chinese)
    calendar.timeZone = timeZone
    return calendar
  }

  private func specialDay(for day: RecurringDay, on date: Date) -> SpecialDay {
    SpecialDay(name: day.name, category: category, detail: day.detail, date: date, kind: .custom)
  }

  /// The start of `day`'s calendar day in the year `yearOffset` years from `date`'s.
  private func occurrence(of day: RecurringDay, yearOffset: Int, from date: Date) -> Date? {
    let calendar = day.reckoning == .lunar ? lunarCalendar : gregorianCalendar
    guard let shifted = calendar.date(byAdding: .year, value: yearOffset, to: date) else { return nil }

    var components = calendar.dateComponents([.era, .year], from: shifted)
    components.month = day.month
    components.day = 1
    if day.reckoning == .lunar { components.isLeapMonth = false }

    guard
      let firstOfMonth = calendar.date(from: components),
      calendar.component(.month, from: firstOfMonth) == day.month,
      let length = calendar.range(of: .day, in: .month, for: firstOfMonth)?.count
    else { return nil }
    if day.reckoning == .lunar, calendar.dateComponents([.month], from: firstOfMonth).isLeapMonth == true {
      return nil
    }

    return calendar.date(byAdding: .day, value: min(day.day, length) - 1, to: firstOfMonth)
      .map { calendar.startOfDay(for: $0) }
  }
}
