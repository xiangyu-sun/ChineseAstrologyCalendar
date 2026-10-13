import Foundation

/// A `SpecialDaySource` that surfaces the 24 solar term (節氣) transition days.
///
/// A date is considered special only on the **first calendar day** of a new
/// solar term (i.e. `Date.isJieqiDay(in: timeZone) == true`). Days within an ongoing term
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

  /// The time zone whose calendar days solar-term start days are reckoned in.
  public let timeZone: TimeZone

  private let contentProvider: any JieqiContentProvider

  /// - Parameters:
  ///   - timeZone: The time zone whose calendar days solar terms fall on.
  ///     Defaults to China Standard Time, matching Chinese almanacs; pass the
  ///     user's time zone to place terms on their local calendar day.
  ///   - contentProvider: Supplies the display strings.
  public init(
    timeZone: TimeZone = .chinaStandardTime,
    contentProvider: any JieqiContentProvider = DefaultJieqiContentProvider()
  ) {
    self.timeZone = timeZone
    self.contentProvider = contentProvider
  }

  public func specialDays(on date: Date) -> [SpecialDay] {
    guard date.isJieqiDay(in: timeZone), let jieqi = date.jieqi(in: timeZone) else { return [] }
    return [SpecialDay(
      name: contentProvider.name(for: jieqi),
      category: contentProvider.category,
      detail: contentProvider.detail(for: jieqi),
      date: date,
      kind: .jieqi
    )]
  }

  public func nextSpecialDay(after date: Date) -> SpecialDay? {
    guard let occurrence = date.nextJieqi(in: timeZone) else { return nil }
    return SpecialDay(
      name: contentProvider.name(for: occurrence.jieqi),
      category: contentProvider.category,
      detail: contentProvider.detail(for: occurrence.jieqi),
      date: occurrence.startDate,
      kind: .jieqi
    )
  }
}
