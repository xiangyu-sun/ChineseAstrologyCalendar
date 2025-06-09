
import Foundation

extension Date {

  /// Returns the ``Day`` value of this date in the specified Chinese calendar.
  public func chineseDay(calendar: Calendar = .chineseCalendar) -> Day? {
    guard let day = dateComponentsFromChineseCalendar(calendar).day else { return nil }
    return Day(rawValue: day)
  }

}
