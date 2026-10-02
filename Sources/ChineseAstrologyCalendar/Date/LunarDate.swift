import Foundation

// MARK: - LunarDate

/// A date in the Chinese lunisolar calendar: the year's stem-branch, the lunar
/// month (including leap months) and the lunar day.
///
/// Build one from a `Date` and render it in any ``DisplayLanguage``:
/// ```swift
/// let lunar = LunarDate(date: Date(), calendar: .chineseCalendarGTM8)
/// lunar?.formatted(.yearZodiacMonthDay, in: .zhHant) // "甲辰龍年正月初一"
/// lunar?.formatted(.yearZodiacMonthDay, in: .zhHans) // "甲辰龙年正月初一"
/// lunar?.formatted(.yearZodiacMonthDay, in: .en)     // "1st Month 1st, Year of the Dragon (Jiǎchén)"
/// ```
public struct LunarDate: Hashable, Sendable {

  /// The year's stem-branch pair (e.g. 甲辰).
  public let year: Ganzhi

  /// The lunar month, which may be a leap month (閏月).
  public let month: LunarMonth

  /// The lunar day of the month (初一 … 三十).
  public let day: Day

  /// The zodiac animal of the year.
  public var zodiac: Zodiac { Zodiac(year.zhi) }

  public init(year: Ganzhi, month: LunarMonth, day: Day) {
    self.year = year
    self.month = month
    self.day = day
  }

  /// The lunar date containing `date`, reckoned in `calendar`'s time zone.
  ///
  /// Pass ``Foundation/Calendar/chineseCalendarGTM8`` to use China Standard
  /// Time, the time zone the calendar is defined in, regardless of where the
  /// device is.
  public init?(date: Date, calendar: Calendar = .chineseCalendar) {
    let components = date.dateComponentsFromChineseCalendar(calendar)
    guard
      let year = components.nian,
      let month = LunarMonth(components: components),
      let dayNumber = components.day,
      let day = Day(rawValue: dayNumber)
    else { return nil }
    self.init(year: year, month: month, day: day)
  }
}

// MARK: - Formatting

extension LunarDate {

  /// Which parts of a ``LunarDate`` to render.
  public enum Style: Sendable, CaseIterable {
    /// The day only: 初九 / "9th".
    case day
    /// Month and day: 五月初九 / "5th Month 9th".
    case monthDay
    /// Year, month and day: 壬寅年五月初九 / "5th Month 9th, Rényín year".
    case yearMonthDay
    /// Year with its zodiac animal, month and day: 壬寅虎年五月初九 /
    /// "5th Month 9th, Year of the Tiger (Rényín)".
    case yearZodiacMonthDay
  }

  /// The date rendered in the given style and language.
  ///
  /// Languages without their own date wording (Russian, Spanish) use English.
  public func formatted(_ style: Style = .yearMonthDay, in language: DisplayLanguage = .zhHant) -> String {
    let dayText = day.localizedName(in: language)
    let monthText = month.localizedName(in: language)
    let yearText = year.localizedName(in: language)

    switch language.base {
    case .zhHant, .zhHans:
      let yearSuffix = "年"
      switch style {
      case .day: return dayText
      case .monthDay: return monthText + dayText
      case .yearMonthDay: return yearText + yearSuffix + monthText + dayText
      case .yearZodiacMonthDay:
        return yearText + zodiac.localizedName(in: language) + yearSuffix + monthText + dayText
      }
    case .en:
      let monthDay = "\(monthText) \(dayText)"
      switch style {
      case .day: return dayText
      case .monthDay: return monthDay
      case .yearMonthDay: return "\(monthDay), \(yearText) year"
      case .yearZodiacMonthDay:
        return "\(monthDay), Year of the \(zodiac.localizedName(in: language)) (\(yearText))"
      }
    }
  }
}

// MARK: - CustomStringConvertible

extension LunarDate: CustomStringConvertible {
  /// The Traditional Chinese year-month-day form, e.g. 壬寅年五月初九.
  public var description: String { formatted(.yearMonthDay, in: .zhHant) }
}

// MARK: - Date + LunarDate

extension Date {
  /// The Chinese lunar date containing this date, in `calendar`'s time zone.
  public func lunarDate(_ calendar: Calendar = .chineseCalendar) -> LunarDate? {
    LunarDate(date: self, calendar: calendar)
  }
}
