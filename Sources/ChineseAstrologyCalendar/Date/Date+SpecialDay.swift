import Foundation

public extension Date {

  // MARK: - What is today?

  /// Returns all special days that fall on this date, queried across the
  /// provided sources. Returns an empty array on ordinary days.
  ///
  /// A single date can match multiple sources simultaneously — for example,
  /// Qingming (清明) is both a `ChineseFestival` and a `Jieqi` transition day,
  /// so it would appear twice with different categories and details.
  ///
  /// Pass a custom `sources` array to mix built-in and third-party sources:
  /// ```swift
  /// let today = Date()
  /// let specials = today.specialDays(sources: [FestivalSource(), JieqiSource(), MySource()])
  ///
  /// if specials.isEmpty {
  ///     print("Ordinary day")
  /// } else {
  ///     for event in specials {
  ///         print("\(event.name) (\(event.category)): \(event.detail)")
  ///     }
  /// }
  /// ```
  ///
  /// - Parameter sources: The data sources to query. Defaults to
  ///   `[FestivalSource(), JieqiSource()]`.
  func specialDays(
    sources: [SpecialDaySource] = [FestivalSource(), JieqiSource()]
  ) -> [SpecialDay] {
    sources.flatMap { $0.specialDays(on: self) }
  }

  // MARK: - What is the next special day?

  /// Finds the nearest upcoming special day after this date, across all
  /// provided sources, and returns it together with how many calendar days
  /// away it is.
  ///
  /// If multiple sources return events on the same date, the one that appears
  /// first in the `sources` array is returned. Call `specialDays(on:)` on the
  /// returned date to get all events for that day.
  ///
  /// ```swift
  /// if let (next, days) = Date().nextSpecialDay() {
  ///     if days == 0 {
  ///         print("Today is \(next.name)!")
  ///     } else {
  ///         print("\(next.name) in \(days) day(s)")
  ///     }
  /// }
  /// ```
  ///
  /// - Parameter sources: The data sources to query. Defaults to
  ///   `[FestivalSource(), JieqiSource()]`.
  /// - Returns: A tuple of the nearest `SpecialDay` and the number of calendar
  ///   days until it occurs, or `nil` if no event is found within the sources'
  ///   search windows.
  func nextSpecialDay(
    sources: [SpecialDaySource] = [FestivalSource(), JieqiSource()]
  ) -> (day: SpecialDay, daysUntil: Int)? {
    let candidates = sources.compactMap { $0.nextSpecialDay(after: self) }
    guard let soonest = candidates.min(by: { $0.date < $1.date }) else {
      return nil
    }
    let calendar = Calendar(identifier: .gregorian)
    let days = calendar.dateComponents([.day], from: self, to: soonest.date).day ?? 0
    return (soonest, max(0, days))
  }
}
