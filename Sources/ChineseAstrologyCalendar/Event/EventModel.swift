import Foundation

// MARK: - EventModel

/// Represents an occurrence of a specific lunar day.
public struct EventModel: Codable {
  /// Creates a new event with the given date and lunar components.
  public init(date: Date, name: Day, dateComponents: DateComponents) {
    self.date = date
    day = name
    self.dateComponents = dateComponents
  }

  /// Gregorian date of the event.
  public let date: Date
  /// Date components in the Chinese calendar.
  public let dateComponents: DateComponents
  /// The lunar day value.
  public let day: Day

  /// Optional display title for the event.
  public var alternativeTitle: String?
}

extension EventModel {

  // MARK: Internal

  var title: String {
    let month = NSNumber(value: dateComponents.month ?? 1)
    return "\(String(describing: EventModel.enToChNumberFormatter.string(from: month))) \(day.name)"
  }

  // MARK: Private

  private static var enToChNumberFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.locale = traditionalChineseLocale
    formatter.numberStyle = .spellOut
    return formatter
  }
}
