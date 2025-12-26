import Foundation

/// Locale configured for Traditional Chinese used in mainland China.
public let traditionalChineseLocale = Locale(identifier: "zh_Hant_CN")

extension NumberFormatter {
  /// Number formatter configured for Traditional Chinese spell-out style.
  ///
  /// This formatter converts numeric values to their Traditional Chinese character equivalents.
  ///
  /// Example:
  /// ```swift
  /// let number = NSNumber(value: 1)
  /// let spelled = NumberFormatter.traditionalChineseNumberFormatter.string(from: number)
  /// // Returns: "一"
  /// ```
  public static let traditionalChineseNumberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = traditionalChineseLocale
    formatter.numberStyle = .spellOut
    return formatter
  }()
  
  /// Legacy name for backward compatibility.
  @available(*, deprecated, renamed: "traditionalChineseNumberFormatter")
  public static let enToChNumberFormatter: NumberFormatter = {
    traditionalChineseNumberFormatter
  }()
}

public extension Int {
  /// Returns the Traditional Chinese character representation of this integer.
  ///
  /// Example:
  /// ```swift
  /// let one = 1
  /// print(one.chineseSpelledOut)  // Prints: "一"
  ///
  /// let twelve = 12
  /// print(twelve.chineseSpelledOut)  // Prints: "十二"
  /// ```
  var chineseSpelledOut: String {
    return NumberFormatter.traditionalChineseNumberFormatter.string(from: NSNumber(value: self)) ?? ""
  }
  
  /// Legacy name for backward compatibility.
  @available(*, deprecated, renamed: "chineseSpelledOut")
  var spelledOut: String {
    return chineseSpelledOut
  }
}
