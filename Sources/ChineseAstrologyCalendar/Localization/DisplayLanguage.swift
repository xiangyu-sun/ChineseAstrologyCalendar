import Foundation

// MARK: - DisplayLanguage

/// A display language for localizable names across the package's enums.
///
/// `.zhHant` (Traditional Chinese) is the library's canonical language and
/// always matches a type's existing `traditionalChineseName`/`chineseCharacter`
/// accessor.
public enum DisplayLanguage: Sendable, CaseIterable {
  /// Traditional Chinese (繁體中文) — the library's canonical language.
  case zhHant
  /// Simplified Chinese (简体中文).
  case zhHans
  /// English.
  case en
}

extension DisplayLanguage {

  /// The display language that best matches the given locale.
  ///
  /// - Chinese locales with a Simplified script (`zh-Hans`, `zh-CN`, `zh-SG`)
  ///   map to `.zhHans`.
  /// - Chinese locales with a Traditional script (`zh-Hant`, `zh-TW`, `zh-HK`,
  ///   `zh-MO`) map to `.zhHant`.
  /// - Any other locale maps to `.en`.
  public init(locale: Locale) {
    let language = locale.identifier.lowercased().replacingOccurrences(of: "_", with: "-")
    guard language.hasPrefix("zh") else {
      self = .en
      return
    }
    if language.contains("hans") || language.contains("-cn") || language.contains("-sg") {
      self = .zhHans
    } else if language.contains("hant")
      || language.contains("-tw")
      || language.contains("-hk")
      || language.contains("-mo") {
      self = .zhHant
    } else {
      // Bare "zh" or an unspecified Chinese region: default to Simplified,
      // the most widely used script.
      self = .zhHans
    }
  }

  /// The display language matching the user's current locale.
  public static var current: DisplayLanguage {
    DisplayLanguage(locale: .current)
  }
}

// MARK: - LocalizedNaming

/// Types that can render their display name in multiple ``DisplayLanguage``s.
public protocol LocalizedNaming {
  /// The display name for this value in the given language.
  func localizedName(in language: DisplayLanguage) -> String
}
