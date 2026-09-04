import Foundation

extension EventModel {

  /// The display title for this event in the given language.
  ///
  /// If ``alternativeTitle`` is set, it is returned as-is for every language.
  /// Otherwise a title is generated from the lunar month and day:
  /// - `.zhHant` / `.zhHans`: the Chinese numeral month plus the day name,
  ///   e.g. `"正月 初一"`.
  /// - `.en`: e.g. `"Month 1, 1st"`.
  public func localizedTitle(in language: DisplayLanguage) -> String {
    if let alternativeTitle {
      return alternativeTitle
    }

    let monthValue = dateComponents.month ?? 1

    switch language {
    case .zhHant, .zhHans:
      let monthNumber = NSNumber(value: monthValue)
      let monthString = NumberFormatter.traditionalChineseNumberFormatter.string(from: monthNumber) ?? "\(monthValue)"
      return "\(monthString) \(day.localizedName(in: language))"
    case .en:
      return "Month \(monthValue), \(day.localizedName(in: .en))"
    }
  }
}
