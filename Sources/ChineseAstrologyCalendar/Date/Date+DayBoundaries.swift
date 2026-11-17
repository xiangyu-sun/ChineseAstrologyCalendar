import Foundation

extension Date {

  /// The first instant of the calendar day that contains this date, in `timeZone`.
  ///
  /// Usually local midnight. On a day whose midnight a daylight-saving change skips (for example
  /// America/Santiago in September or Asia/Beirut in March), it is the first instant that exists,
  /// such as 01:00.
  public func startOfDay(in timeZone: TimeZone) -> Date {
    Self.gregorianCalendar(in: timeZone).startOfDay(for: self)
  }

  /// The starts of the next `count` calendar days in `timeZone`, strictly after this date and strictly increasing.
  ///
  /// Use these as widget or timeline refresh points so that day-based content (solar terms, festivals,
  /// countdowns) rolls over at midnight in the zone the content is reckoned in, for example China
  /// Standard Time, rather than at the device's local midnight. Each value is ``startOfDay(in:)`` of its
  /// day, so a midnight skipped by daylight saving becomes the first instant of that day.
  ///
  /// - Returns: An empty array when `count` is zero or negative.
  public func nextMidnights(count: Int, in timeZone: TimeZone) -> [Date] {
    guard count > 0 else { return [] }
    let calendar = Self.gregorianCalendar(in: timeZone)
    var result: [Date] = []
    result.reserveCapacity(count)
    var cursor = self
    while result.count < count {
      let next = Self.startOfNextDay(after: cursor, calendar: calendar)
      result.append(next)
      cursor = next
    }
    return result
  }

  /// The start of the calendar day after the one containing `date`; always later than `date`.
  private static func startOfNextDay(after date: Date, calendar: Calendar) -> Date {
    if let interval = calendar.dateInterval(of: .day, for: date), interval.end > date {
      return interval.end
    }
    // Fallback: step a day from the start of this day, then realign to that day's start.
    let start = calendar.startOfDay(for: date)
    if let following = calendar.date(byAdding: .day, value: 1, to: start) {
      let aligned = calendar.startOfDay(for: following)
      if aligned > date { return aligned }
      if following > date { return following }
    }
    return date.addingTimeInterval(86_400)
  }

  private static func gregorianCalendar(in timeZone: TimeZone) -> Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = timeZone
    return calendar
  }
}
