import Foundation

// MARK: - LunarMonth

/// A month of the Chinese lunisolar calendar, including leap months (閏月).
///
/// ```swift
/// let month = Date().lunarMonth
/// month?.localizedName(in: .zhHant) // "臘月", "閏四月", …
/// month?.localizedName(in: .en)     // "12th Month", "Leap 4th Month", …
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
  /// leap months. English uses ordinals: "1st Month", "Leap 4th Month".
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language {
    case .zhHant:
      return (isLeap ? "閏" : "") + Self.traditionalNames[number - 1]
    case .zhHans:
      return (isLeap ? "闰" : "") + Self.simplifiedNames[number - 1]
    case .en:
      return (isLeap ? "Leap " : "") + "\(Day.englishOrdinal(number)) Month"
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
}

// MARK: - Date + LunarMonth

extension Date {
  /// The Chinese lunar month containing this date, in the given calendar's
  /// time zone (the current time zone by default).
  public func lunarMonth(_ calendar: Calendar = .chineseCalendar) -> LunarMonth? {
    LunarMonth(components: dateComponentsFromChineseCalendar(calendar))
  }
}
