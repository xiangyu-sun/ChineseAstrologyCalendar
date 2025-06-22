
import Foundation

/// Represents a traditional two-hour period of the day.
public struct Shichen: Codable {

  // MARK: Lifecycle

  /// Creates a ``Shichen`` for the given earthly branch and date.
  public init(dizhi: Dizhi, date: Date) {
    self.dizhi = dizhi
    self.date = date
  }

  // MARK: Public

  /// Earthly branch associated with the period.
  public let dizhi: Dizhi
  /// Reference date used for calculations.
  public let date: Date

  /// Length of one ``ke`` in seconds.
  public var ke: Double { 15 * 60 }

  /// ``ke`` index within this ``Shichen`` based on ``date``.
  public var currentKe: Int {
    Int((date.timeIntervalSince1970 - startDate.timeIntervalSince1970) / ke)
  }

  /// Start date for this ``Shichen``.
  public var startDate: Date {
    let startHour = dizhi.hourInterval.start

    var startDP = Calendar.current.dateComponents(
      [.year, .month, .day, .hour, .minute, .second, .nanosecond],
      from: date)

    if startHour == 23, startDP.hour == 0 {
      startDP.day = startDP.day! - 1
    }

    startDP.hour = startHour
    startDP.minute = 0
    startDP.second = 0
    startDP.nanosecond = 0

    return Calendar.current.date(from: startDP) ?? Date()
  }

  /// End date for this ``Shichen``.
  public var endDate: Date {
    let endHour = dizhi.hourInterval.end

    var endDP = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)

    if endHour == 0, endDP.hour == 23 {
      endDP.day = endDP.day! + 1
    }

    endDP.hour = endHour
    endDP.minute = 59
    endDP.second = 59

    return Calendar.current.date(from: endDP) ?? Date()
  }

  /// Start date of the next ``Shichen``.
  public var nextStartDate: Date {
    let startHour = dizhi.next.hourInterval.start

    var startDP = Calendar.current.dateComponents(
      [.year, .month, .day, .hour, .minute, .second, .nanosecond],
      from: date)

    // If the next start hour is earlier than or equal to the current hour,
    // it belongs to the next day.
    if let currentHour = startDP.hour, startHour <= currentHour {
      startDP.day = (startDP.day ?? 0) + 1
    }

    startDP.hour = startHour
    startDP.minute = 0
    startDP.second = 0
    startDP.nanosecond = 0

    return Calendar.current.date(from: startDP) ?? Date()
  }
}
