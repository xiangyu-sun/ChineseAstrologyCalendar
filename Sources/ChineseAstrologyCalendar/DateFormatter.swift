
import Foundation

extension TimeZone {
  /// Time zone used for China Standard Time (GMT+8).
  static let chinaStandardTime = TimeZone(abbreviation: "GMT+8") ?? .autoupdatingCurrent
}

extension Calendar {

  /// Chinese calendar configured with China Standard Time.
  public static let chineseCalendarGTM8: Calendar = {
    var calendar = Calendar(identifier: .chinese)
    calendar.timeZone = .chinaStandardTime
    return calendar
  }()

  /// Chinese calendar using the current time zone.
  public static var chineseCalendar: Calendar {
    Calendar(identifier: .chinese)
  }
}

extension DateFormatter {

  /// Formatter for displaying Chinese dates in the current time zone.
  public static let chineseTranditionalChineseDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.calendar = Calendar.chineseCalendar
    df.dateStyle = .long
    df.locale = Locale(identifier: "zh_Hant")
    return df
  }()

  /// Formatter for displaying Chinese dates in China Standard Time.
  public static let chineseTranditionalChineseDateFormatterWithGTM8: DateFormatter = {
    let df = DateFormatter()
    df.calendar = Calendar.chineseCalendar
    df.dateStyle = .long
    df.timeZone = .chinaStandardTime
    df.locale = Locale(identifier: "zh_Hant")
    return df
  }()
}
