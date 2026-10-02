import Foundation

// MARK: - DisplayLanguage

/// A language the package can render display strings in.
///
/// `DisplayLanguage` is a struct rather than an enum so that new languages can
/// be added in a minor release without breaking `switch` statements in client
/// code. Compare against the static members (`language == .zhHans`), or switch
/// with a `default:` branch.
///
/// Built-in languages:
/// - ``zhHant`` — Traditional Chinese, the library's canonical language. It
///   always matches a type's `traditionalChineseName` / `chineseCharacter`.
/// - ``zhHans`` — Simplified Chinese.
/// - ``en`` — English.
/// - ``ru`` — Russian, and ``es`` — Spanish. Festival and solar-term names and
///   descriptions are translated; every other type falls back to English.
public struct DisplayLanguage: Hashable, Sendable, CustomStringConvertible {

  /// The BCP 47 identifier of the language, e.g. `"zh-Hant"` or `"en"`.
  public let identifier: String

  private init(uncheckedIdentifier: String) {
    identifier = uncheckedIdentifier
  }

  /// Traditional Chinese (繁體中文) — the library's canonical language.
  public static let zhHant = DisplayLanguage(uncheckedIdentifier: "zh-Hant")
  /// Simplified Chinese (简体中文).
  public static let zhHans = DisplayLanguage(uncheckedIdentifier: "zh-Hans")
  /// English.
  public static let en = DisplayLanguage(uncheckedIdentifier: "en")
  /// Russian (русский). Types without Russian text fall back to English.
  public static let ru = DisplayLanguage(uncheckedIdentifier: "ru")
  /// Spanish (español). Types without Spanish text fall back to English.
  public static let es = DisplayLanguage(uncheckedIdentifier: "es")

  public var description: String { identifier }
}

// MARK: CaseIterable

extension DisplayLanguage: CaseIterable {
  /// Every built-in language. New languages may be appended in minor releases.
  public static let allCases: [DisplayLanguage] = [.zhHant, .zhHans, .en, .ru, .es]
}

// MARK: Resolving a locale

extension DisplayLanguage {

  /// The built-in language that best matches the given locale.
  ///
  /// See ``init(identifier:)`` for the matching rules.
  public init(locale: Locale) {
    self.init(identifier: locale.identifier)
  }

  /// The built-in language that best matches a BCP 47 or ICU locale
  /// identifier such as `"zh-Hant-TW"`, `"zh_CN"` or `"es-MX"`.
  ///
  /// - Chinese: an explicit script wins (`zh-Hant-CN` is Traditional,
  ///   `zh-Hans-HK` is Simplified). Without a script, `TW`, `HK` and `MO` mean
  ///   Traditional and anything else (including bare `zh`) means Simplified.
  /// - Russian and Spanish identifiers match ``ru`` and ``es`` in any region.
  /// - Any other language resolves to ``en``.
  ///
  /// Pass `Bundle.main.preferredLocalizations.first` to follow the language
  /// your app's UI is actually shown in, which can differ from `Locale.current`.
  public init(identifier: String) {
    let subtags = identifier
      .lowercased()
      .split(whereSeparator: { $0 == "-" || $0 == "_" || $0 == "@" })
      .map(String.init)
    switch subtags.first {
    case "zh":
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
    case "ru":
      self = .ru
    case "es":
      self = .es
    default:
      self = .en
    }
  }

  /// The built-in language matching the user's current locale.
  ///
  /// In an app, prefer `DisplayLanguage(identifier: Bundle.main.preferredLocalizations.first ?? "en")`,
  /// which reflects the language the app's UI is displayed in.
  public static var current: DisplayLanguage {
    DisplayLanguage(locale: .current)
  }
}

// MARK: Codable

extension DisplayLanguage: Codable {
  /// Decodes from the language's identifier string, e.g. `"zh-Hant"`.
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.init(identifier: try container.decode(String.self))
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(identifier)
  }
}

// MARK: - Script fallback

/// The three scripts every type in the package is translated into. Languages
/// without their own text for a type render it in English.
enum BaseLanguage {
  case zhHant
  case zhHans
  case en
}

extension DisplayLanguage {
  /// The base language to use for types that only carry Chinese and English text.
  var base: BaseLanguage {
    switch self {
    case .zhHant: return .zhHant
    case .zhHans: return .zhHans
    default: return .en
    }
  }
}

// MARK: - LocalizedNaming

/// Types that can render their display name in multiple ``DisplayLanguage``s.
///
/// Downstream packages adopt this protocol for their own types. Implementations
/// should render every language: switch over the languages you translate and
/// use English (or Traditional Chinese) in a `default:` branch.
public protocol LocalizedNaming {
  /// The display name for this value in the given language.
  func localizedName(in language: DisplayLanguage) -> String
}
