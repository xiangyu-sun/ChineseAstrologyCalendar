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
    return (soonest, calendarDays(to: soonest.date, in: Calendar(identifier: .gregorian)))
  }

  // MARK: - Today, or the next special day

  /// The special day falling on this date, or failing that the nearest
  /// upcoming one, with the number of calendar days until it.
  ///
  /// Unlike ``nextSpecialDay(sources:)`` — which only ever looks *after* this
  /// date — this returns today's event with `daysUntil == 0` on the day itself,
  /// which is what a "today / next" display needs.
  ///
  /// When several sources match the same day, the first in `sources` wins
  /// (冬至 is both a festival and a solar term).
  ///
  /// - Parameters:
  ///   - sources: The data sources to query, in priority order.
  ///   - calendar: The calendar whose days `daysUntil` counts. Use one in the
  ///     same time zone as the sources.
  func currentOrNextSpecialDay(
    sources: [SpecialDaySource] = [FestivalSource(), JieqiSource()],
    calendar: Calendar = Calendar(identifier: .gregorian)
  ) -> (day: SpecialDay, daysUntil: Int)? {
    if let today = specialDays(sources: sources).first {
      return (today, 0)
    }
    let candidates = sources.compactMap { $0.nextSpecialDay(after: self) }
    guard let soonest = candidates.min(by: { $0.date < $1.date }) else { return nil }
    return (soonest, calendarDays(to: soonest.date, in: calendar))
  }

  // MARK: - Everything coming up

  /// Every special day from this date's calendar day through the next `days`
  /// calendar days, soonest first, each with the number of days until it.
  ///
  /// Events with the same name on the same day are reported once (the first
  /// source in `sources` wins); events on the same day keep `sources` order.
  ///
  /// ```swift
  /// for (event, days) in Date().upcomingSpecialDays(within: 30) {
  ///     print("\(event.name) in \(days) day(s)")
  /// }
  /// ```
  func upcomingSpecialDays(
    sources: [SpecialDaySource] = [FestivalSource(), JieqiSource()],
    within days: Int = 365,
    calendar: Calendar = Calendar(identifier: .gregorian)
  ) -> [(day: SpecialDay, daysUntil: Int)] {
    var found: [(day: SpecialDay, daysUntil: Int, order: Int)] = []
    for (order, source) in sources.enumerated() {
      for event in source.specialDays(on: self) {
        found.append((event, 0, order))
      }
      var probe = self
      // Bounded so a misbehaving source can't loop forever.
      for _ in 0..<500 {
        guard let next = source.nextSpecialDay(after: probe), next.date > probe else { break }
        let until = calendarDays(to: next.date, in: calendar)
        guard until <= days else { break }
        found.append((next, until, order))
        probe = next.date
      }
    }
    found.sort { ($0.daysUntil, $0.order) < ($1.daysUntil, $1.order) }

    var seen = Set<String>()
    return found.compactMap { item in
      seen.insert("\(item.daysUntil)|\(item.day.name)").inserted ? (item.day, item.daysUntil) : nil
    }
  }
}

// MARK: - Helpers

extension Date {
  /// Whole calendar days from this date's day to `other`'s day in `calendar`.
  fileprivate func calendarDays(to other: Date, in calendar: Calendar) -> Int {
    let from = calendar.startOfDay(for: self)
    let to = calendar.startOfDay(for: other)
    return max(0, calendar.dateComponents([.day], from: from, to: to).day ?? 0)
  }
}
