import Foundation

// MARK: - EventModel

/// Represents an occurrence of a specific lunar day in the Chinese calendar.
///
/// `EventModel` encapsulates a complete event tied to the lunar calendar system,
/// including its Gregorian date, lunar date components, and the specific lunar day.
///
/// Example:
/// ```swift
/// let converter = DayConverter()
/// let events = converter.find(days: [.chuyi, .shiwu], inNextMonths: 3)
/// for event in events {
///     print("\(event.title) on \(event.date)")
/// }
/// ```
public struct EventModel: Codable, Identifiable, Equatable {
  
  // MARK: Lifecycle
  
  /// Creates a new event with the given date and lunar components.
  ///
  /// - Parameters:
  ///   - date: The Gregorian date of the event.
  ///   - name: The lunar day associated with this event.
  ///   - dateComponents: The date components in the Chinese calendar system.
  public init(date: Date, name: Day, dateComponents: DateComponents) {
    self.date = date
    self.day = name
    self.dateComponents = dateComponents
  }

  // MARK: Public
  
  /// Unique identifier for the event, based on its date.
  public var id: Date { date }
  
  /// Gregorian date of the event.
  public let date: Date
  
  /// Date components in the Chinese calendar.
  public let dateComponents: DateComponents
  
  /// The lunar day value.
  public let day: Day

  /// Optional custom display title for the event.
  ///
  /// When set, this overrides the default generated title.
  /// Use this to provide culturally specific or contextual titles.
  public var alternativeTitle: String?
}

// MARK: - Title Generation

extension EventModel {
  
  /// The display title for this event.
  ///
  /// Generates a Traditional Chinese title combining the month number
  /// (spelled out) and the lunar day name.
  ///
  /// Example output: "正月 初一" (First month, first day)
  ///
  /// - Note: Returns the alternative title if one has been set,
  ///   otherwise generates the title from date components.
  var title: String {
    if let alternativeTitle = alternativeTitle {
      return alternativeTitle
    }
    
    let monthValue = dateComponents.month ?? 1
    let monthNumber = NSNumber(value: monthValue)
    let monthString = NumberFormatter.enToChNumberFormatter.string(from: monthNumber) ?? "\(monthValue)"
    
    return "\(monthString) \(day.name)"
  }
}
