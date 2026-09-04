import Foundation

// MARK: - LocalizedJieqiContentProvider

/// A `JieqiContentProvider` that supplies a Simplified Chinese or English
/// display name for each ``Jieqi``.
///
/// Only `name(for:)` is translated. `detail(for:)` (the TCM `healthTip`) is
/// dense, medically-adjacent classical text; auto-translating it risked
/// introducing inaccurate health claims, so it intentionally falls back to
/// the library's Traditional Chinese text for every ``DisplayLanguage``.
/// Inject your own ``JieqiContentProvider`` if you need a translated `detail`.
///
/// ```swift
/// let source = JieqiSource(contentProvider: LocalizedJieqiContentProvider(language: .en))
/// ```
public struct LocalizedJieqiContentProvider: JieqiContentProvider {

  public let language: DisplayLanguage

  public init(language: DisplayLanguage) {
    self.language = language
  }

  public func name(for jieqi: Jieqi) -> String {
    jieqi.localizedName(in: language)
  }

  public func detail(for jieqi: Jieqi) -> String {
    jieqi.healthTip
  }

  public var category: String {
    switch language {
    case .zhHant: return JieqiSource.categoryName
    case .zhHans: return "节气"
    case .en: return "Solar Term"
    }
  }
}
