
import Foundation

/// Represents a traditional two-hour period of the day.
///
/// A Shichen (時辰) is one of twelve two-hour periods in traditional Chinese timekeeping,
/// each associated with an Earthly Branch (Dizhi). This structure provides methods to
/// calculate start and end times, as well as subdivisions called "ke" (刻).
public struct Shichen: Codable {

  // MARK: Lifecycle

  /// Creates a ``Shichen`` for the given earthly branch and date.
  ///
  /// - Parameters:
  ///   - dizhi: The earthly branch defining this time period
  ///   - date: Reference date within this Shichen period
  ///   - calendar: Calendar to use for calculations (defaults to current Gregorian)
  ///   - timeZone: TimeZone for calculations (defaults to current)
  public init(
    dizhi: Dizhi, 
    date: Date,
    calendar: Calendar = Calendar.current,
    timeZone: TimeZone = TimeZone.current
  ) {
    self.dizhi = dizhi
    self.date = date
    var cal = calendar
    cal.timeZone = timeZone
    self.calendar = cal
  }

  // MARK: Public

  /// Earthly branch associated with the period.
  public let dizhi: Dizhi
  
  /// Reference date used for calculations.
  public let date: Date
  
  /// Calendar used for all date calculations.
  public let calendar: Calendar

  /// Length of one ``ke`` (刻, quarter-hour) in seconds.
  ///
  /// A ke is a traditional Chinese time unit equal to 15 minutes.
  public static let keLength: Double = 15 * 60
  
  /// Length of one ``ke`` in seconds (instance accessor for convenience).
  public var ke: Double { Self.keLength }

  /// ``ke`` index within this ``Shichen`` based on ``date``.
  ///
  /// Returns a value from 0 to 7, representing which quarter-hour (ke) within
  /// the two-hour period the reference date falls into.
  ///
  /// - Note: Returns 0 if the date falls before the start of this Shichen.
  public var currentKe: Int {
    let elapsed = date.timeIntervalSince1970 - startDate.timeIntervalSince1970
    return max(0, min(7, Int(elapsed / Self.keLength)))
  }
  
  static let keMapping = ["初", "二", "三", "四", "五", "六", "七", "末"]
  
  public var currentKeSpellOut: String {
    return Self.keMapping[currentKe]
  }

  /// Start date for this ``Shichen``.
  ///
  /// Returns the precise moment when this two-hour period begins.
  /// Handles the special case of Zi (子) hour which starts at 23:00 on the previous day.
  ///
  /// - Note: Falls back to the reference date if calculation fails.
  public var startDate: Date {
    let startHour = dizhi.hourInterval.start

    var startDP = calendar.dateComponents(
      [.year, .month, .day, .hour, .minute, .second, .nanosecond],
      from: date)

    // Handle Zi hour (子時) which starts at 23:00 the previous day
    if startHour == 23, let currentHour = startDP.hour, currentHour < 23 {
      startDP.day = (startDP.day ?? 1) - 1
    }

    startDP.hour = startHour
    startDP.minute = 0
    startDP.second = 0
    startDP.nanosecond = 0

    return calendar.date(from: startDP) ?? date
  }

  /// End date for this ``Shichen``.
  ///
  /// Returns the last moment of this two-hour period (hour:59:59.999999999).
  /// Handles the special case where Zi (子) hour ends at 00:59 the next day.
  ///
  /// - Note: Falls back to two hours after the reference date if calculation fails.
  public var endDate: Date {
    let endHour = dizhi.hourInterval.end

    var endDP = calendar.dateComponents(
      [.year, .month, .day, .hour, .minute, .second, .nanosecond], 
      from: date)

    // Handle Zi hour (子時) which ends at 00:59 the next day
    if endHour == 0, let currentHour = endDP.hour, currentHour >= 23 {
      endDP.day = (endDP.day ?? 1) + 1
    }

    endDP.hour = endHour
    endDP.minute = 59
    endDP.second = 59
    endDP.nanosecond = 999_999_999 // Last possible nanosecond

    return calendar.date(from: endDP) ?? date.addingTimeInterval(7200)
  }

  /// Start date of the next ``Shichen``.
  ///
  /// Returns the beginning of the subsequent two-hour period.
  ///
  /// - Note: Falls back to two hours after start date if calculation fails.
  public var nextStartDate: Date {
    let nextDizhi = dizhi.next
    let nextStartHour = nextDizhi.hourInterval.start

    var nextDP = calendar.dateComponents(
      [.year, .month, .day, .hour, .minute, .second, .nanosecond],
      from: date)

    // Determine if we need to advance to the next day
    if let currentHour = nextDP.hour {
      // If next start hour is less than or equal to current hour,
      // and it's not a same-day transition, advance to next day
      if nextStartHour <= currentHour || nextStartHour == 23 {
        // Check if this is actually a next-day scenario
        let currentStart = dizhi.hourInterval.start
        if nextStartHour < currentStart || (currentStart == 23 && nextStartHour < 23) {
          nextDP.day = (nextDP.day ?? 1) + 1
        }
      }
    }

    nextDP.hour = nextStartHour
    nextDP.minute = 0
    nextDP.second = 0
    nextDP.nanosecond = 0

    return calendar.date(from: nextDP) ?? startDate.addingTimeInterval(7200)
  }
}
// MARK: - Equatable

extension Shichen: Equatable {
  public static func == (lhs: Shichen, rhs: Shichen) -> Bool {
    lhs.dizhi == rhs.dizhi && 
    lhs.startDate == rhs.startDate
  }
}

// MARK: - Hashable

extension Shichen: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(dizhi)
    hasher.combine(startDate)
  }
}

// MARK: - Comparable

extension Shichen: Comparable {
  /// Orders Shichen by their start date.
  public static func < (lhs: Shichen, rhs: Shichen) -> Bool {
    lhs.startDate < rhs.startDate
  }
}

// MARK: - CustomStringConvertible

extension Shichen: CustomStringConvertible {
  public var description: String {
    "Shichen(\(dizhi.chineseCharacter), ke: \(currentKe))"
  }
}

// MARK: - Additional Helpers

extension Shichen {
  /// Returns the date range representing this Shichen as a closed range.
  public var dateInterval: DateInterval {
    DateInterval(start: startDate, end: endDate)
  }
  
  /// Returns the duration of this Shichen in seconds (always 7200 = 2 hours).
  public var duration: TimeInterval {
    7200
  }
  
  /// Checks if a given date falls within this Shichen period.
  ///
  /// - Parameter date: The date to check
  /// - Returns: `true` if the date is within this Shichen's time range
  public func contains(_ testDate: Date) -> Bool {
    testDate >= startDate && testDate <= endDate
  }
  
  /// Returns the next Shichen after this one.
  ///
  /// - Returns: A new Shichen instance representing the next period
  public func next() -> Shichen {
    Shichen(dizhi: dizhi.next, date: nextStartDate, calendar: calendar, timeZone: calendar.timeZone)
  }
  
  /// Returns the previous Shichen before this one.
  ///
  /// - Returns: A new Shichen instance representing the previous period
  public func previous() -> Shichen {
    let previousDate = startDate.addingTimeInterval(-7200)
    return Shichen(dizhi: dizhi.previous, date: previousDate, calendar: calendar, timeZone: calendar.timeZone)
  }
}

