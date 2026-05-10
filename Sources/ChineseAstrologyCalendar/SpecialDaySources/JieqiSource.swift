import Foundation

/// A `SpecialDaySource` that surfaces the 24 solar term (節氣) transition days.
///
/// A date is considered special only on the **first calendar day** of a new
/// solar term (i.e. `Date.isJieqiDay == true`). Days within an ongoing term
/// are not surfaced — they are a background attribute, not a special event.
///
/// Inject a custom ``JieqiContentProvider`` to supply localised or alternate
/// display strings without modifying the `Jieqi` enum:
///
/// ```swift
/// let source = JieqiSource(contentProvider: EnglishJieqiContent())
/// let sources: [SpecialDaySource] = [FestivalSource(), source]
/// let today = Date().specialDays(sources: sources)
/// ```
public struct JieqiSource: SpecialDaySource {

  /// The default category string used in `SpecialDay.category` for all jieqi events.
  public static let categoryName = "節氣"

  private let contentProvider: any JieqiContentProvider

  public init(contentProvider: any JieqiContentProvider = DefaultJieqiContentProvider()) {
    self.contentProvider = contentProvider
  }

  public func specialDays(on date: Date) -> [SpecialDay] {
    guard date.isJieqiDay, let jieqi = date.jieqi else { return [] }
    return [SpecialDay(
      name: contentProvider.name(for: jieqi),
      category: contentProvider.category,
      detail: contentProvider.detail(for: jieqi),
      date: date
    )]
  }

  public func nextSpecialDay(after date: Date) -> SpecialDay? {
    let calendar = Calendar(identifier: .gregorian)
    guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: date) else {
      return nil
    }
    guard let (jieqi, _) = tomorrow.nextJieqi,
          let nextDate = jieqi.nextDate(after: tomorrow) else {
      return nil
    }
    return SpecialDay(
      name: contentProvider.name(for: jieqi),
      category: contentProvider.category,
      detail: contentProvider.detail(for: jieqi),
      date: nextDate
    )
  }
}
