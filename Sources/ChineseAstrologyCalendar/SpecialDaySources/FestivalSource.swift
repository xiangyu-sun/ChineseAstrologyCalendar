import Foundation

/// A `SpecialDaySource` that surfaces traditional Chinese festivals.
///
/// Uses `Date.chineseFestival` to detect the current festival and
/// `ChineseFestival.nextDate(from:converter:)` to find the next one.
///
/// Inject a custom ``ChineseFestivalContentProvider`` to supply localised or
/// alternate display strings without modifying the `ChineseFestival` enum:
///
/// ```swift
/// let source = FestivalSource(contentProvider: EnglishFestivalContent())
/// let sources: [SpecialDaySource] = [source, JieqiSource()]
/// let today = Date().specialDays(sources: sources)
/// ```
public struct FestivalSource: SpecialDaySource {

  /// The default category string used in `SpecialDay.category` for all festival events.
  public static let categoryName = "節日"

  private let converter: DayConverter
  private let timeZone: TimeZone?
  private let contentProvider: any ChineseFestivalContentProvider

  /// - Parameters:
  ///   - converter: Finds lunar festival dates.
  ///   - timeZone: The time zone whose calendar days both lunar and solar-term
  ///     festivals (清明, 冬至) are matched on. Pass the same time zone as
  ///     `converter`'s calendar. `nil` (the default) keeps the original
  ///     behaviour: lunar festivals in the device time zone, solar-term
  ///     festivals in China Standard Time.
  ///   - contentProvider: Supplies the display strings.
  public init(
    converter: DayConverter = DayConverter(),
    timeZone: TimeZone? = nil,
    contentProvider: any ChineseFestivalContentProvider = DefaultFestivalContentProvider()
  ) {
    self.converter = converter
    self.timeZone = timeZone
    self.contentProvider = contentProvider
  }

  public func specialDays(on date: Date) -> [SpecialDay] {
    let match = timeZone.map { date.chineseFestival(timeZone: $0) } ?? date.chineseFestival
    guard let festival = match else { return [] }
    return [SpecialDay(
      name: contentProvider.name(for: festival),
      category: contentProvider.category,
      detail: contentProvider.detail(for: festival),
      date: date,
      kind: .festival
    )]
  }

  public func nextSpecialDay(after date: Date) -> SpecialDay? {
    // Find the next occurrence across all festivals and return the soonest.
    let candidates = ChineseFestival.allCases.compactMap { festival -> (ChineseFestival, Date)? in
      guard let next = nextDate(of: festival, from: date) else { return nil }
      // nextDate(from:) may return `date` itself if it is the festival day;
      // we want strictly after `date`.
      var calendar = Calendar(identifier: .gregorian)
      if let timeZone { calendar.timeZone = timeZone }
      guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: date) else { return nil }
      if next < tomorrow {
        // The returned date is today or earlier — find next year's occurrence.
        return nextDate(of: festival, from: tomorrow).map { (festival, $0) }
      }
      return (festival, next)
    }

    guard let (festival, nextDate) = candidates.min(by: { $0.1 < $1.1 }) else {
      return nil
    }

    return SpecialDay(
      name: contentProvider.name(for: festival),
      category: contentProvider.category,
      detail: contentProvider.detail(for: festival),
      date: nextDate,
      kind: .festival
    )
  }

  private func nextDate(of festival: ChineseFestival, from date: Date) -> Date? {
    guard let timeZone else { return festival.nextDate(from: date, converter: converter) }
    return festival.nextDate(from: date, converter: converter, timeZone: timeZone)
  }
}
