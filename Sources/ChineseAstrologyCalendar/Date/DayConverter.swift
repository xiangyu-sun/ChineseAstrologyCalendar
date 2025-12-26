import Foundation

// MARK: - DayConverter

/// Utility for locating specific lunar days within a range of dates.
///
/// `DayConverter` provides methods to search for occurrences of specific lunar days,
/// either by scanning upcoming months or years. This is useful for calculating
/// festival dates, moon phases, or recurring lunar events.
///
/// Example:
/// ```swift
/// let converter = DayConverter()
///
/// // Find next three months of new moons and full moons
/// let events = converter.find(days: [.chuyi, .shiwu], inNextMonths: 3)
/// for event in events {
///     print("\(event.day.name): \(event.date)")
/// }
/// ```
public final class DayConverter {

  // MARK: Lifecycle

  /// Creates a converter using the specified calendar.
  ///
  /// - Parameter calendar: The calendar system to use for date calculations.
  ///   Defaults to the Chinese calendar.
  public init(calendar: Calendar = .chineseCalendar) {
    self.calendar = calendar
  }

  // MARK: Public

  /// The calendar system used for date calculations.
  public let calendar: Calendar

  /// Finds upcoming occurrences of the given days in the next number of months.
  ///
  /// This method searches for all occurrences of the specified lunar days
  /// within the specified number of months from the start date.
  ///
  /// Example:
  /// ```swift
  /// let converter = DayConverter()
  /// // Find all 15th days (full moons) in the next 6 months
  /// let fullMoons = converter.find(days: [.shiwu], inNextMonths: 6)
  /// ```
  ///
  /// - Parameters:
  ///   - days: Array of lunar days to search for.
  ///   - inNextMonths: Number of months to search ahead.
  ///   - date: Starting date for the search. Defaults to the current date.
  /// - Returns: Array of events matching the criteria, sorted chronologically.
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
  ///
  /// This method is useful for finding recurring annual events, such as
  /// festivals that occur on a specific lunar day and month each year.
  ///
  /// Example:
  /// ```swift
  /// let converter = DayConverter()
  /// // Find next 5 occurrences of the Mid-Autumn Festival (15th day of 8th month)
  /// let midAutumn = converter.find(day: .shiwu, month: .shen, inNextYears: 5)
  /// ```
  ///
  /// - Parameters:
  ///   - day: The lunar day to search for.
  ///   - month: The lunar month (as an Earthly Branch).
  ///   - inNextYears: Number of years to search ahead (inclusive of current year).
  ///   - date: Starting date for the search. Defaults to the current date.
  /// - Returns: Array of events matching the criteria, sorted chronologically.
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
  ///
  /// This method searches for specific days within a single lunar month.
  ///
  /// Example:
  /// ```swift
  /// let converter = DayConverter()
  /// // Find the 1st and 15th days of the first lunar month
  /// let springFestival = converter.find(days: [.chuyi, .shiwu], month: .yin)
  /// ```
  ///
  /// - Parameters:
  ///   - days: Array of lunar days to search for.
  ///   - month: The lunar month (as an Earthly Branch).
  ///   - date: Starting date for the search. Defaults to the current date.
  /// - Returns: Array of events matching the criteria, sorted chronologically.
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

  /// Validates that the constructed date matches the expected components.
  ///
  /// This ensures that the date created from components accurately represents
  /// the intended lunar date, and that it's not in the past.
  func isValid(component: DateComponents, targetDate: Date, originDate: Date) -> Bool {
    targetDate >= originDate && calendar
      .dateComponents([.era, .year, .month, .day], from: targetDate) == component
  }

}
