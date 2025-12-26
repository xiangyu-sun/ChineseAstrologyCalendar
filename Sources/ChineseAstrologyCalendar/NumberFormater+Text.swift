import Foundation

/// Locale configured for Traditional Chinese used in mainland China.
public let traditionalChineseLocale = Locale(identifier: "zh_Hant_CN")

extension NumberFormatter {
  static let enToChNumberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = traditionalChineseLocale
    formatter.numberStyle = .spellOut
    return formatter
  }()
}


public extension Int {
  var spelledOut: String {
    return NumberFormatter.enToChNumberFormatter.string(from: NSNumber(value: self)) ?? ""
  }
}
