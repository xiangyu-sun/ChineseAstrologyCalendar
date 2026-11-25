import Foundation

// MARK: - LunarMonth

/// A month of the Chinese lunisolar calendar, including leap months (閏月).
///
/// ```swift
/// let month = Date().lunarMonth
/// month?.localizedName(in: .zhHant) // "臘月", "閏四月", …
/// month?.localizedName(in: .en)     // "12th Month", "Leap 4th Month", …
/// month?.localizedName(in: .es)     // "12.º mes", "4.º mes intercalar", …
/// ```
public struct LunarMonth: Hashable, Sendable, Codable {

  /// The month number, 1 (正月) through 12 (臘月).
  public let number: Int

  /// Whether this is an intercalary month (閏月) repeating `number`.
  public let isLeap: Bool

  /// Returns `nil` unless `number` is in `1...12`.
  public init?(number: Int, isLeap: Bool = false) {
    guard (1...12).contains(number) else { return nil }
    self.number = number
    self.isLeap = isLeap
  }

  /// The month described by Chinese-calendar date components, as produced by
  /// ``Foundation/Date/dateComponentsFromChineseCalendar(_:)``.
  public init?(components: DateComponents) {
    guard let month = components.month else { return nil }
    self.init(number: month, isLeap: components.isLeapMonth ?? false)
  }
}

// MARK: LocalizedNaming

extension LunarMonth: LocalizedNaming {
  /// The month's traditional name: 正月 … 十月, 冬月, 臘月, prefixed with 閏 for
  /// leap months. English uses ordinals ("1st Month", "Leap 4th Month"), as
  /// does Spanish ("1.er mes", "4.º mes intercalar").
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language.base {
    case .zhHant:
      return (isLeap ? "閏" : "") + Self.traditionalNames[number - 1]
    case .zhHans:
      return (isLeap ? "闰" : "") + Self.simplifiedNames[number - 1]
    case .en:
      return (isLeap ? "Leap " : "") + "\(Day.englishOrdinal(number)) Month"
    case .es:
      return "\(Self.spanishOrdinals[number - 1]) mes" + (isLeap ? " intercalar" : "")
    }
  }

  private static let traditionalNames = [
    "正月", "二月", "三月", "四月", "五月", "六月",
    "七月", "八月", "九月", "十月", "冬月", "臘月",
  ]

  private static let simplifiedNames = [
    "正月", "二月", "三月", "四月", "五月", "六月",
    "七月", "八月", "九月", "十月", "冬月", "腊月",
  ]

  // 1.er and 3.er: Spanish shortens "primer" and "tercer" before "mes".
  private static let spanishOrdinals = [
    "1.er", "2.º", "3.er", "4.º", "5.º", "6.º",
    "7.º", "8.º", "9.º", "10.º", "11.º", "12.º",
  ]
}

// MARK: - Date + LunarMonth

extension Date {
  /// The Chinese lunar month containing this date, in the given calendar's
  /// time zone (the current time zone by default).
  public func lunarMonth(_ calendar: Calendar = .chineseCalendar) -> LunarMonth? {
    LunarMonth(components: dateComponentsFromChineseCalendar(calendar))
  }
}
