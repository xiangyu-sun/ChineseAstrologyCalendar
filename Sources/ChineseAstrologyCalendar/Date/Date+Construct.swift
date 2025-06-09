
import Foundation

extension DateComponents {
  /// Constructs a ``Date`` from Chinese calendar components.
  public static func getDate(year: Int, month: Int, day: Day) -> Date? {
    let adjustedYear = year + 2697
    let chineseEra = Int(adjustedYear / 60)
    let chineseYear = adjustedYear - chineseEra * 60

    let dateComponent = DateComponents(
      calendar: .chineseCalendar,
      era: chineseEra,
      year: chineseYear,
      month: month,
      day: day.rawValue)

    return Calendar.chineseCalendar.date(from: dateComponent)
  }
}
