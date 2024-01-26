
import Foundation

extension Date {

  public func chineseDay(calendar: Calendar = .chineseCalendar) -> Day? {
    guard let day = dateComponentsFromChineseCalendar(calendar).day else { return nil }
    return Day(rawValue: day)
  }

}
