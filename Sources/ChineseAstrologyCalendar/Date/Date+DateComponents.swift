
import Foundation

/// Helpers for extracting ``DateComponents`` in different calendars.
extension Date {

  // MARK: Public

  /// .era,.year,.month,.day,.hour,.minute,.second, .nanosecond
  public var dateComponentsFromCurrentCalendar: DateComponents {
    Calendar.current.dateComponents([.era, .year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
  }

  /// Chinese calendar date components without converting the year to modulo 60.
  public func dateComponentsFromChineseCalendar(_ calendar: Calendar = .chineseCalendar) -> DateComponents {
    Date.chineseENDateFormatter.timeZone = calendar.timeZone
    let elements = Date.chineseENDateFormatter.string(from: self).split(separator: "/")
    let day = Int(elements[1])
    let month: Int?
    let year = Int(elements[2])
    
    var isLeapMonth = false

    if elements[0].contains("bis") {
        isLeapMonth = true
        // Extract numeric part before "bis"
        if let number = Int(elements[0].replacingOccurrences(of: "bis", with: "")) {
            month = number
        } else {
          month = nil
        }
    } else if let number = Int(elements[0]) {
        month = number
    }else {
      month = nil
    }

    let orginalDateComponents = dateComponentsFromCurrentCalendar

    var dp = DateComponents(calendar: calendar)
    dp.day = day
    dp.month = month
    dp.era = orginalDateComponents.chineseEra
    dp.year = year
    dp.hour = orginalDateComponents.hour
    dp.minute = orginalDateComponents.minute
    dp.second = orginalDateComponents.second
    dp.nanosecond = orginalDateComponents.nanosecond
    dp.isLeapMonth = isLeapMonth
    return dp
  }

  // MARK: Internal

  static let chineseENDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.calendar = Calendar.chineseCalendar
    df.dateStyle = .short
    df.locale = Locale(identifier: "en_US")
    return df
  }()
}
