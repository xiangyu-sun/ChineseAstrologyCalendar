import Foundation

/// A `SpecialDaySource` that surfaces traditional Chinese festivals.
///
/// Uses `Date.chineseFestival` to detect the current festival and
/// `ChineseFestival.nextDate(from:converter:)` to find the next one.
///
/// ```swift
/// let sources: [SpecialDaySource] = [FestivalSource(), JieqiSource()]
/// let today = Date().specialDays(sources: sources)
/// ```
public struct FestivalSource: SpecialDaySource {

  /// The category string used in `SpecialDay.category` for all festival events.
  public static let categoryName = "節日"

  private let converter: DayConverter

  public init(converter: DayConverter = DayConverter()) {
    self.converter = converter
  }

  public func specialDays(on date: Date) -> [SpecialDay] {
    guard let festival = date.chineseFestival else { return [] }
    return [SpecialDay(
      name: festival.chineseName,
      category: Self.categoryName,
      detail: festival.meaning,
      date: date
    )]
  }

  public func nextSpecialDay(after date: Date) -> SpecialDay? {
    // Find the next occurrence across all festivals and return the soonest.
    let candidates = ChineseFestival.allCases.compactMap { festival -> (ChineseFestival, Date)? in
      guard let next = festival.nextDate(from: date, converter: converter) else { return nil }
      // nextDate(from:) may return `date` itself if it is the festival day;
      // we want strictly after `date`.
      let calendar = Calendar(identifier: .gregorian)
      guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: date) else { return nil }
      if next < tomorrow {
        // The returned date is today or earlier — find next year's occurrence.
        return festival.nextDate(from: tomorrow, converter: converter).map { (festival, $0) }
      }
      return (festival, next)
    }

    guard let (festival, nextDate) = candidates.min(by: { $0.1 < $1.1 }) else {
      return nil
    }

    return SpecialDay(
      name: festival.chineseName,
      category: Self.categoryName,
      detail: festival.meaning,
      date: nextDate
    )
  }
}
