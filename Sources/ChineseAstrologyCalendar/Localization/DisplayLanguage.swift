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
  /// An explicit script wins over the region, so `zh-Hant-CN` is Traditional
  /// and `zh-Hans-HK` is Simplified.
  /// - Chinese locales with a Simplified script (`zh-Hans`), or with no script
  ///   and a region other than Taiwan, Hong Kong or Macau (`zh-CN`, `zh-SG`,
  ///   bare `zh`), map to `.zhHans`.
  /// - Chinese locales with a Traditional script (`zh-Hant`), or with no script
  ///   and a `TW`, `HK` or `MO` region, map to `.zhHant`.
  /// - Any other locale maps to `.en`.
  public init(locale: Locale) {
    self.init(identifier: locale.identifier)
  }

  /// The display language that best matches a BCP 47 or ICU locale
  /// identifier such as `"zh-Hant-TW"` or `"zh_CN"`.
  ///
  /// Pass `Bundle.main.preferredLocalizations.first` to follow the language
  /// your app's UI is actually shown in, which can differ from `Locale.current`.
  public init(identifier: String) {
    let subtags = identifier
      .lowercased()
      .split(whereSeparator: { $0 == "-" || $0 == "_" || $0 == "@" })
      .map(String.init)
    guard subtags.first == "zh" else {
      self = .en
      return
    }
    if subtags.contains("hant") {
      self = .zhHant
    } else if subtags.contains("hans") {
      self = .zhHans
    } else if subtags.contains(where: { ["tw", "hk", "mo"].contains($0) }) {
      self = .zhHant
    } else {
      // Bare "zh" or a mainland/Singapore region: Simplified is the default script.
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
