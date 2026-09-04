import Foundation

extension Day: LocalizedNaming {
  /// The lunar day name in the given language.
  ///
  /// The Chinese forms (初一…三十) are identical in Traditional and Simplified
  /// script, so both return ``name``. English returns an ordinal ("1st"…"30th").
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language {
    case .zhHant, .zhHans:
      return name
    case .en:
      return Self.englishOrdinal(rawValue)
    }
  }

  private static func englishOrdinal(_ n: Int) -> String {
    let suffix: String
    switch (n % 100, n % 10) {
    case (11, _), (12, _), (13, _): suffix = "th"
    case (_, 1): suffix = "st"
    case (_, 2): suffix = "nd"
    case (_, 3): suffix = "rd"
    default: suffix = "th"
    }
    return "\(n)\(suffix)"
  }
}
