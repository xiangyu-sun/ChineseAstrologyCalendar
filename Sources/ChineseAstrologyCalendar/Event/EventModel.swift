import Foundation

// MARK: - EventModel

public struct EventModel: Codable {
  public init(date: Date, name: Day, dateComponents: DateComponents) {
    self.date = date
    day = name
    self.dateComponents = dateComponents
  }

  public let date: Date
  public let dateComponents: DateComponents
  public let day: Day

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
    formatter.locale = tranditonalChineseLocal
    formatter.numberStyle = .spellOut
    return formatter
  }
}
