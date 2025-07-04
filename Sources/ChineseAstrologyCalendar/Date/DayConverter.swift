import Foundation

/// Utility for locating specific lunar days within a range of dates.
public final class DayConverter {

  // MARK: Lifecycle

  /// Creates a converter using the specified calendar.
  public init(calendar: Calendar = .chineseCalendar) {
    self.calendar = calendar
  }

  // MARK: Public

  /// Finds upcoming occurrences of the given days in the next number of months.
  public func find(days: [Day], inNextMonths: Int, from date: Date = Date()) -> [EventModel] {
    let components = calendar.dateComponents([.era, .year, .month, .day], from: date)

    return Array(0..<inNextMonths).reduce(into: [EventModel]()) { result, month in

      for d in days {
        var copy = components

        let newMonth = (copy.month! + month)
        let newYear: Float = (Float(newMonth) / 13.0).rounded(.towardZero)

        copy.month = newMonth <= 12 ? newMonth : newMonth - 12
        copy.year! += Int(newYear)
        copy.day = d.rawValue

        guard
          let targetDate = calendar.date(from: copy),
          isValid(component: copy, targetDate: targetDate, originDate: date)
        else {
          continue
        }

        result.append(EventModel(date: targetDate, name: d, dateComponents: copy))
      }
    }
  }

  /// Finds future occurrences of a specific day and month over several years.
  public func find(day: Day, month: Dizhi, inNextYears: Int, from date: Date = Date()) -> [EventModel] {
    let components = calendar.dateComponents([.era, .year, .month, .day], from: date)
    let monthConverted = (Dizhi.orderedMonthAlCases.firstIndex(of: month) ?? 0) + 1
    return Array(0...inNextYears).reduce(into: [EventModel]()) { result, year in

      var copy = components
      copy.month = monthConverted
      copy.year! += Int(year)
      copy.day = day.rawValue

      guard
        let targetDate = calendar.date(from: copy),
        isValid(component: copy, targetDate: targetDate, originDate: date)
      else {
        return
      }

      result.append(EventModel(date: targetDate, name: day, dateComponents: copy))
    }
  }

  /// Finds events for the provided days in a fixed month of the current year.
  public func find(days: [Day], month: Dizhi, from date: Date = Date()) -> [EventModel] {
    let components = calendar.dateComponents([.era, .year, .month, .day], from: date)
    let monthConverted = (Dizhi.orderedMonthAlCases.firstIndex(of: month) ?? 0) + 1

    return days.reduce(into: [EventModel]()) { result, day in

      var copy = components
      copy.month = monthConverted
      copy.day = day.rawValue

      guard
        let targetDate = calendar.date(from: copy),
        isValid(component: copy, targetDate: targetDate, originDate: date)
      else {
        return
      }

      result.append(EventModel(date: targetDate, name: day, dateComponents: copy))
    }
  }

  // MARK: Internal

  let calendar: Calendar

  func isValid(component: DateComponents, targetDate: Date, originDate: Date) -> Bool {
    targetDate >= originDate && calendar
      .dateComponents([.era, .year, .month, .day], from: targetDate) == component
  }

}
