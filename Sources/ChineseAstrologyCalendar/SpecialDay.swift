import Foundation

// MARK: - SpecialDayKind

/// A stable, locale-independent identifier for the kind of source that
/// produced a ``SpecialDay``.
///
/// Unlike ``SpecialDay/category`` — which is a localized *display* string and
/// therefore changes with language — a `SpecialDayKind` is safe to compare
/// against in code (e.g. to filter or branch on event type):
///
/// ```swift
/// let festivals = Date().specialDays().filter { $0.kind == .festival }
/// ```
///
/// It is backed by a raw `String` so third-party ``SpecialDaySource``
/// implementations can define their own kinds.
public struct SpecialDayKind: RawRepresentable, Hashable, Sendable {
  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }

  /// A traditional Chinese festival (produced by ``FestivalSource``).
  public static let festival = SpecialDayKind(rawValue: "festival")

  /// A solar-term transition day (produced by ``JieqiSource``).
  public static let jieqi = SpecialDayKind(rawValue: "jieqi")

  /// A custom event kind from a third-party source that did not specify one.
  public static let custom = SpecialDayKind(rawValue: "custom")
}

// MARK: - SpecialDay

/// A unified representation of a "special day" in the Chinese calendar.
///
/// `SpecialDay` is a display-ready summary of any calendar event — a festival,
/// a solar term transition, or a custom event from a third-party source.
/// It carries just enough information to render a UI entry; use the originating
/// source's own APIs for deeper data.
///
/// ```swift
/// let today = Date().specialDays()
/// for event in today {
///     print("\(event.name) (\(event.category)): \(event.detail)")
/// }
/// ```
public struct SpecialDay: Sendable {

  /// The traditional Chinese display name for this event (e.g. "清明節", "冬至").
  public let name: String

  /// An open-string category label identifying the source type
  /// (e.g. "節日", "節氣"). Using a `String` rather than a closed enum
  /// lets third-party `SpecialDaySource` implementations define their own
  /// categories without modifying this library.
  public let category: String

  /// A brief contextual description suitable for display as a subtitle
  /// (e.g. the festival's cultural meaning, or a TCM health tip).
  public let detail: String

  /// The Gregorian date on which this event occurs.
  public let date: Date

  /// A stable, locale-independent identifier for the source kind.
  ///
  /// Use this — not ``category`` — when comparing or filtering events in code,
  /// since ``category`` is a localized display string.
  public let kind: SpecialDayKind

  public init(name: String, category: String, detail: String, date: Date, kind: SpecialDayKind = .custom) {
    self.name = name
    self.category = category
    self.detail = detail
    self.date = date
    self.kind = kind
  }
}

// MARK: - SpecialDaySource

/// A plug-in data source that provides special day information for given dates.
///
/// Conform to this protocol to add new types of special days to the system.
/// Built-in implementations (`FestivalSource`, `JieqiSource`) are provided.
///
/// ## Implementing a custom source
/// ```swift
/// struct MyHolidaySource: SpecialDaySource {
///     func specialDays(on date: Date) -> [SpecialDay] {
///         // Return SpecialDay values if `date` is a holiday
///     }
///     func nextSpecialDay(after date: Date) -> SpecialDay? {
///         // Return the soonest upcoming holiday strictly after `date`
///     }
/// }
///
/// // Plug it in alongside the built-in sources:
/// let sources: [SpecialDaySource] = [FestivalSource(), JieqiSource(), MyHolidaySource()]
/// let today = Date().specialDays(sources: sources)
/// ```
public protocol SpecialDaySource {

  /// Returns all special days that fall on the given date, or an empty array
  /// if the date is not special for this source.
  func specialDays(on date: Date) -> [SpecialDay]

  /// Returns the next special day occurring strictly after the given date,
  /// or `nil` if none is found within a reasonable search window.
  func nextSpecialDay(after date: Date) -> SpecialDay?
}
