
import Foundation

extension TimeZone {
  static let chinaStandardTime = TimeZone(abbreviation: "GMT+8") ?? .autoupdatingCurrent
}

extension Calendar {

  public static let chineseCalendarGTM8: Calendar = {
    var calendar = Calendar(identifier: .chinese)
    calendar.timeZone = .chinaStandardTime
    return calendar
  }()

  public static var chineseCalendar: Calendar {
    Calendar(identifier: .chinese)
  }
}

extension DateFormatter {

  public static let chineseTranditionalChineseDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.calendar = Calendar.chineseCalendar
    df.dateStyle = .long
    df.locale = Locale(identifier: "zh_Hant")
    return df
  }()

  public static let chineseTranditionalChineseDateFormatterWithGTM8: DateFormatter = {
    let df = DateFormatter()
    df.calendar = Calendar.chineseCalendar
    df.dateStyle = .long
    df.timeZone = .chinaStandardTime
    df.locale = Locale(identifier: "zh_Hant")
    return df
  }()
}
